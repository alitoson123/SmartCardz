import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/widgets/camera_or_gallery_dialog.dart';
import 'package:smart_cards/core/services/image_service/picking_an_image.dart';

Future<void> showImagePickerDialog(BuildContext context, Function(File) onImagePicked) async {
  if (!context.mounted) return;

  await showDialog(
    context: context,
    builder: (dialogContext) {
      return CameraOrGalleryDialog(
        onPressedGallery: () async {
          final picked = await PickingAnImage().pickImageFromGallery();
          if (!dialogContext.mounted) return;
          Navigator.pop(dialogContext);
          if (picked != null) {
            onImagePicked(picked);
          }
        },
        onPressedCamera: () async {
          final picked = await PickingAnImage().pickImageFromCamera();
          if (!dialogContext.mounted) return;
          Navigator.pop(dialogContext);
          if (picked != null) {
            onImagePicked(picked);
          }
        },
      );
    },
  );
}
