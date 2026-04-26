import { onDocumentDeleted } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";

admin.initializeApp();


/* =========================
   2️⃣ DELETE CARD IMAGES
========================= */
export const deleteCardImages = onDocumentDeleted(
  "cards/{cardId}",
  async (event) => {
    const data = event.data?.data();
    if (!data) return;

    const bucket = admin.storage().bucket();
    const paths = [
      data.front_image_path,
      data.back_image_path,
      data.ai_image_path
    ].filter(Boolean);

    await Promise.all(
      paths.map((path: string) =>
        bucket.file(path).delete().catch(err =>
          console.error("Failed to delete image:", err)
        )
      )
    );
  }
);
