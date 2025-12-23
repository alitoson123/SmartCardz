import { onSchedule } from "firebase-functions/v2/scheduler";
import * as admin from "firebase-admin";

admin.initializeApp();

// Configuration
const BATCH_SIZE = 500; // Process 500 users at a time to stay under memory/timeout limits

export const dueCardsNotification = onSchedule({
  schedule: "0 0 */5 * *",
  timeZone: "Africa/Cairo",
  timeoutSeconds: 540, // Increase timeout to 9 minutes for large datasets
  memory: "512MiB",    // Slightly more memory for processing batches
}, async () => {
  const db = admin.firestore();
  const now = admin.firestore.Timestamp.now();
  let lastDoc = null;
  let totalProcessed = 0;

  console.log("Starting notification cycle...");

  while (true) {
    // 1. Fetch users in batches using pagination
    let query = db.collection("users").orderBy("__name__").limit(BATCH_SIZE);
    
    if (lastDoc) {
      query = query.startAfter(lastDoc);
    }

    const usersSnap = await query.get();

    if (usersSnap.empty) {
      break; // No more users to process
    }

    // 2. Process the current batch of users
    await Promise.all(
      usersSnap.docs.map(async (userDoc) => {
        const userId = userDoc.id;
        const data = userDoc.data();
        const token = data.fcmToken;

        if (!token) return;

        // 3. Count due cards for this specific user
        const cardsSnap = await db.collection("cards")
          .where("ownerId", "==", userId)
          .where("next_review", "<=", now)
          .get();

        const dueCount = cardsSnap.size;

        if (dueCount >= 10) {
          try {
            await admin.messaging().send({
              token,
              notification: {
                title: "مجدول للمراجعة",
                body: `عندك ${dueCount} بطاقة محتاجة مراجعة`,
              },
              data: {
                type: "due_cards",
                count: dueCount.toString(),
              },
            });
          } catch (error) {
            console.error(`Failed to send to user ${userId}:`, error);
          }
        }
      })
    );

    totalProcessed += usersSnap.docs.length;
    lastDoc = usersSnap.docs[usersSnap.docs.length - 1];
    
    console.log(`Processed ${totalProcessed} users so far...`);
  }

  console.log("Notification cycle complete.");
});