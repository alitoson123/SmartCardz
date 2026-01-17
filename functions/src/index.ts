import { onSchedule } from "firebase-functions/v2/scheduler";
import { onDocumentCreated, onDocumentDeleted } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";

admin.initializeApp();

/* =========================
   1️⃣ DUE CARDS NOTIFICATION
========================= */
const BATCH_SIZE = 500;

export const dueCardsNotification = onSchedule(
  {
    schedule: "0 0 */5 * *",
    timeZone: "Africa/Cairo",
    timeoutSeconds: 540,
    memory: "512MiB",
  },
  async () => {
    const db = admin.firestore();
    const now = admin.firestore.Timestamp.now();
    let lastDoc: FirebaseFirestore.QueryDocumentSnapshot | null = null;

    while (true) {
      let query = db.collection("users").orderBy("__name__").limit(BATCH_SIZE);
      if (lastDoc) query = query.startAfter(lastDoc);

      const usersSnap = await query.get();
      if (usersSnap.empty) break;

      await Promise.all(
        usersSnap.docs.map(async (userDoc) => {
          const token = userDoc.data().fcmToken;
          if (!token) return;

          const cardsSnap = await db
            .collection("cards")
            .where("ownerId", "==", userDoc.id)
            .where("next_review", "<=", now)
            .get();

          if (cardsSnap.size >= 10) {
            await admin.messaging().send({
              token,
              notification: {
                title: "مجدول للمراجعة",
                body: `عندك ${cardsSnap.size} بطاقة محتاجة مراجعة`,
              },
              data: {
                type: "due_cards",
              },
            });
          }
        })
      );

      lastDoc = usersSnap.docs.at(-1)!;
    }
  }
);

/* =========================
   2️⃣ DELETE CARD IMAGES
========================= */
export const deleteCardImages = onDocumentDeleted(
  "cards/{cardId}",
  async (event) => {
    const data = event.data?.data();
    if (!data) return;

    const bucket = admin.storage().bucket();
    const paths = [data.front_image_path, data.back_image_path].filter(Boolean);

    await Promise.all(
      paths.map((path: string) =>
        bucket.file(path).delete().catch(err =>
          console.error("Failed to delete image:", err)
        )
      )
    );
  }
);

/* =========================
   3️⃣ AI PROCESSING
========================= */
interface AIResponse {
  word: string;
  definition: string;
  example: string;
  type: string;
  image_url?: string;
}


async function fetchAI(word: string): Promise<AIResponse> {
  const url =
    `https://n8n.srv1209874.hstgr.cloud/webhook/smartcardiz` +
    `?words=${encodeURIComponent(word)}` +
    `&lang=العربي` +
    `&age=56` +
    `&level=مبتدئ` +
    `&style=رسم` +
    `&country=مصر`;

  const response = await fetch(url, {
    method: "GET",
    headers: {
      "Accept": "application/json",
    },
  });

  const text = await response.text();

  if (!response.ok) {
    console.error("AI raw response:", text);
    throw new Error(`AI request failed: ${response.status}`);
  }

  if (!text) {
    throw new Error("AI returned empty response");
  }

  try {
    return JSON.parse(text) as AIResponse;
  } catch (err) {
    console.error("Invalid JSON from AI:", text);
    throw new Error("AI response is not valid JSON");
  }
}

export const processAICard = onDocumentCreated(
  "ai_requests/{requestId}",
  async (event) => {
    const data = event.data?.data();
    if (!data || data.status !== "pending") return;

    const ref = event.data!.ref;

    try {
      await ref.update({ status: "processing" });

      const ai = await fetchAI(data.word);

      await ref.update({
        status: "done",
        result: ai,
      });

      const user = await admin.firestore()
        .collection("users")
        .doc(data.userId)
        .get();

      const token = user.data()?.fcmToken;
      if (token) {
        await admin.messaging().send({
          token,
          notification: {
            title: "الكارت جاهز 🎉",
            body: "اضغط لمعاينة الكارت",
          },
          data: {
            type: "ai_preview",
            requestId: event.params.requestId,
          },
        });
      }
    } catch (err: any) {
      console.error("AI FAILED:", err);

      await ref.update({
        status: "error",
        errorMessage: err.message ?? "AI generation failed",
      });
    }
  }
);
