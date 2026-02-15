import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

class PutImageAndGetUrl {
  static Future<String> putAndGetUrl(
    Reference? imageRef,
    File imageFile,
  ) async {
    try {
      final compressedImage = await compressImage(imageFile);  // compress image

      await imageRef!.putFile(compressedImage);  // upload image

      final imageUrl = await imageRef.getDownloadURL();

      // Seed the cache with the local file so it's available offline immediately
      try { // cache image
        await DefaultCacheManager().putFile(
          imageUrl,
          await compressedImage.readAsBytes(),
          fileExtension: 'webp',
        );
      } catch (e) {
        log('Cache seeding failed: $e');
      }

      log('✅ Upload successful!');
      return imageUrl; // return image url
    } catch (e) {
      log('❌ Upload error: $e');
      return "";
    }
  }

  static Future<File> compressImage(File file) async { // compress image
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.webp';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 75, // جودة ممتازة وحجم قليل
      minWidth: 1080, // تصغير العرض لـ1080
      format: CompressFormat.webp, // WebP يقلل الحجم جداً
    );

    if (result == null) {
      throw Exception("Image compression failed");
    }

    return File(result.path);
  }

  // Generate storage reference for image
  static Reference? generateImageReference({ // generate storage reference for image with user id and card id and side
    required String side,
    required String cardId,
  }) {
    User? user = FirebaseAuth.instance.currentUser;
    final String userId = user!.uid;

    final storageRef = FirebaseStorage.instance.ref();

    final imageRef = storageRef.child('cards/$userId/$cardId/$side.webp');

    return imageRef;
  }
}
