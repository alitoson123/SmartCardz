import { onDocumentDeleted, onDocumentUpdated } from "firebase-functions/v2/firestore";
import * as admin from "firebase-admin";

admin.initializeApp();


/* =========================
   1️⃣ DELETE CARD IMAGES ON UPDATE (edit card)
========================= */
export const cleanupCardImagesOnUpdate = onDocumentUpdated(
  "cards/{cardId}",
  async (event) => {
    const before = event.data?.before.data();
    const after = event.data?.after.data();
    if (!before || !after) return;

    const bucket = admin.storage().bucket();

    // الـ fields اللي ممكن فيها صورة في النوعين
    const imagePathFields = [
      "front_image_path",
      "back_image_path",
      "ai_image_path",
    ];

    const pathsToDelete: string[] = [];

    for (const field of imagePathFields) {
      const oldPath = before[field];
      const newPath = after[field];

      // الصورة اتمسحت لو كانت فيها path وبقت "" أو null أو undefined
      const wasRemoved = oldPath && !newPath;

      // الصورة اتغيرت لو الـ path اتبدل بـ path تاني
      const wasReplaced = oldPath && newPath && oldPath !== newPath;

      if (wasRemoved || wasReplaced) {
        pathsToDelete.push(oldPath);
      }
    }

    if (pathsToDelete.length === 0) return;

    await Promise.all(
      pathsToDelete.map((path: string) =>
        bucket
          .file(path)
          .delete()
          .catch((err) => console.error(`Failed to delete image [${path}]:`, err))
      )
    );
  }
);


/* =========================
   2️⃣ DELETE CARD IMAGES ON DELETE
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
      data.ai_image_path,
    ].filter(Boolean);

    await Promise.all(
      paths.map((path: string) =>
        bucket
          .file(path)
          .delete()
          .catch((err) => console.error("Failed to delete image:", err))
      )
    );
  }
);