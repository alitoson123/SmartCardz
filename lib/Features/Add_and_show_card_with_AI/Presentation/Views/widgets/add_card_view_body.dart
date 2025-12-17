import 'package:flutter/material.dart';

class AddCardViewBody extends StatelessWidget {
  const AddCardViewBody({super.key, this.onSaved});
  final void Function(String)? onSaved;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              onChanged: onSaved,
              decoration: const InputDecoration(
                //  labelText: 'Enter a new word',
                hintText: 'Enter a new word',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
