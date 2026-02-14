/*import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/generated/l10n.dart';

class ContentOfDialog extends StatefulWidget {
  const ContentOfDialog({
    super.key,
    required this.controller,
    required this.isButtonEnabled ,
    required this.isLoading,
  });
  final TextEditingController controller;
   bool isButtonEnabled;
   bool isLoading;
  @override
  State<ContentOfDialog> createState() => _ContentOfDialogState();
}

class _ContentOfDialogState extends State<ContentOfDialog> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 0.75.sw,
      child: TextField(
        cursorColor: Colors.blueAccent,
        controller: widget.controller,
        autofocus: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          focusColor: Colors.blueAccent,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(10.r),
          ),
          hintText: S.of(context).enterCollectionName,
          hintStyle: TextStyle(color: Colors.grey[400]),
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        onChanged: (value) {
          setState(() => widget.isButtonEnabled = value.trim().isNotEmpty);
        },
      ),
    );
  }
}
*/