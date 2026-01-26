import 'package:flutter/material.dart';
import 'package:smart_cards/generated/l10n.dart';

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
      title: Text(S.of(context).chooseAnOption),
      children: [
        SimpleDialogOption(
          onPressed: widget.onPressedGallery,
          child: Text(S.of(context).chooseFromGallery),
        ),
        SimpleDialogOption(
          onPressed: widget.onPressedCamera,
          child: Text(S.of(context).chooseFromCamera),
        ),
      ],
    );
  }
}
