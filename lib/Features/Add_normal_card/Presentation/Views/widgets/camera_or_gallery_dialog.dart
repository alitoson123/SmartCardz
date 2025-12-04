import 'package:flutter/material.dart';

class CameraOrGalleryDialog extends StatefulWidget {
  const CameraOrGalleryDialog({
    super.key,
    this.onPressedCamera,
    this.onPressedGallery,
  });
  final void Function()? onPressedCamera;
  final void Function()? onPressedGallery;

  @override
  State<CameraOrGalleryDialog> createState() => _CameraOrGalleryDialogState();
}

class _CameraOrGalleryDialogState extends State<CameraOrGalleryDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text('Choose an option'),
      children: [
        SimpleDialogOption(
          child: Text('Choose from gallery'),
          onPressed: widget.onPressedGallery,
        ),
        SimpleDialogOption(
          child: Text('Choose from camera'),
          onPressed: widget.onPressedCamera,
        ),
      ],
    );
  }
}
