import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/add_collection_cubit/add_collection_cubit.dart';


class CreateCollectionDialog extends StatefulWidget {
  const CreateCollectionDialog({super.key});

  @override
  State<CreateCollectionDialog> createState() => _CreateCollectionDialogState();
}

class _CreateCollectionDialogState extends State<CreateCollectionDialog> {
  final TextEditingController controller = TextEditingController();
  bool isButtonEnabled = false;
  bool isLoading = false;

  void createCollection(BuildContext context) async {
    setState(() => isLoading = true);

    context.read<AddCollectionCubit>().addCollectionMethod(
      collectionName: controller.text.trim(),
    );

    Navigator.pop(context); // close dialog

    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: Colors.white,
      title: const Text(
        '🗂️ Create a New Collection',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: Colors.black,
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * .75, // 👈 makes it wider
        child: TextField(
          cursorColor: Colors.blueAccent,
          controller: controller,
          autofocus: true,
          style: const TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            focusColor: Colors.blueAccent,
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blueAccent),
              borderRadius: BorderRadius.circular(10),
            ),
            hintText: 'Enter collection name...',
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onChanged: (value) {
            setState(() => isButtonEnabled = value.trim().isNotEmpty);
          },
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: isButtonEnabled && !isLoading
              ? () => createCollection(context)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isButtonEnabled
                ? Colors.blueAccent
                : Colors.grey[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
