import 'dart:io';

import 'package:image_picker/image_picker.dart';

class PickingAnImage {
  final ImagePicker picker = ImagePicker();

  // Pick image from gallery and return File
  Future<File?> pickImageFromGallery() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return null;

    return File(pickedImage.path);
  }

  // Pick image from camera and return File
  Future<File?> pickImageFromCamera() async {
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage == null) return null;

    return File(pickedImage.path);
  }
}
