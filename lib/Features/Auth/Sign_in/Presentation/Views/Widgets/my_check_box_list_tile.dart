import 'package:flutter/material.dart';

class MyCheckBoxListTile extends StatelessWidget {
  const MyCheckBoxListTile(
      {super.key, required this.value, required this.onChanged});
  final bool value;
  final void Function(bool?) onChanged;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CheckboxListTile(
          contentPadding: EdgeInsets.zero, // removes extra padding
          visualDensity:
              VisualDensity(horizontal: -4, vertical: -4), // tighter spacing
          title: Text('Remember me'),
          controlAffinity: ListTileControlAffinity.leading,
          value: value,
          onChanged: onChanged),
    );
  }
}
