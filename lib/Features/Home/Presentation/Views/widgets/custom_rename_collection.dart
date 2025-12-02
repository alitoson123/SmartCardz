import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';


class CustomRenameCollection extends StatefulWidget {
  const CustomRenameCollection({super.key, required this.collection});

  final CollectionEntity collection;

  @override
  State<CustomRenameCollection> createState() => _CustomRenameCollectionState();
}

class _CustomRenameCollectionState extends State<CustomRenameCollection> {
  final TextEditingController controller = TextEditingController();
  bool isButtonEnabled = false;

    @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rename Collection'),
      content: TextField(
        controller: controller,
        onChanged: (value) {
          setState(() => isButtonEnabled = value.trim().isNotEmpty);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Collection Name',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.red)),
        ),
        TextButton(
          onPressed: isButtonEnabled
              ? () {
                  AppServices.renameCollection(
                    collectionId: widget.collection.collection_id,
                    newCollectionName: controller.text,
                  );
                  Navigator.pop(context); 
                  Navigator.pop(context);
                } 
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isButtonEnabled
                ? Colors.blueAccent
                : Colors.grey[700],
                  shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text('rename', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
    
  }
}
