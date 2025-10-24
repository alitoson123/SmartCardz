import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:smart_cards/core/Functions/scaff_message.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';
import 'package:smart_cards/core/utils/routes.dart';

class AddOptions extends StatelessWidget {
  const AddOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      backgroundColor: Colors.blueAccent,
      spacing: 10,
      spaceBetweenChildren: 8,
      elevation: 6,
      children: [
        SpeedDialChild(
          child: const Icon(Icons.auto_awesome, color: Colors.white),
          backgroundColor: Colors.blueAccent,
          label: 'Add Card with AI',
          labelStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          labelBackgroundColor: Colors.blueAccent.withOpacity(0.9),
          onTap: () {
            context.push(AppRoutes.addAndShowCardScreen);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.add_box, color: Colors.white),
          backgroundColor: Colors.blueAccent,
          label: 'Add Card',
          labelStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          labelBackgroundColor: Colors.blueAccent.withOpacity(0.9),
          onTap: () {
            context.push(AppRoutes.addNormalCardScreen);
          },
        ),
        SpeedDialChild(
          child: const Icon(Icons.folder_copy, color: Colors.white),
          backgroundColor: Colors.blueAccent,
          label: 'Create New Collection',
          labelStyle: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          labelBackgroundColor: Colors.blueAccent.withOpacity(0.9),
          onTap: () async {
            final appServices = AppServices(dio: Dio());

            try {
              showDialog(
                context: context,
                builder: (context) => const CreateCollectionDialog(),
              );
            } catch (e) {
              showScaffMessage(context, e.toString(), color: Colors.redAccent);
            }
          },
        ),
      ],
    );
  }
}

class CreateCollectionDialog extends StatefulWidget {
  const CreateCollectionDialog({super.key});

  @override
  State<CreateCollectionDialog> createState() => _CreateCollectionDialogState();
}

class _CreateCollectionDialogState extends State<CreateCollectionDialog> {
  final TextEditingController _controller = TextEditingController();
  bool _isButtonEnabled = false;
  bool _isLoading = false;

  void _createCollection(BuildContext context) async {
    setState(() => _isLoading = true);

    final appServices = AppServices(dio: Dio());

    try {
      await appServices.createNewCollection(
        collectionName: _controller.text.trim(),
      );

      Navigator.pop(context); // close dialog
      showScaffMessage(context, 'Collection created successfully');
    } catch (e) {
      showScaffMessage(context, e.toString(), color: Colors.redAccent);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
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
          controller: _controller,
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
            setState(() => _isButtonEnabled = value.trim().isNotEmpty);
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
          onPressed: _isButtonEnabled && !_isLoading
              ? () => _createCollection(context)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isButtonEnabled
                ? Colors.blueAccent
                : Colors.grey[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          ),
          child: _isLoading
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
