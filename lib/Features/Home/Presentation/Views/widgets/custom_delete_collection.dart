import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';

class CustomDeleteCollection extends StatelessWidget {
  const CustomDeleteCollection({super.key, required this.collection});
  final CollectionEntity collection;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Collection'),
      content: const Text(
        'Are you sure you want to delete this collection? This action cannot be undone.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            AppServices.deleteCollection(
              collectionId: collection.collection_id,
            );
            Navigator.pop(context); // Close AlertDialog
            Navigator.pop(context); // Close SimpleDialog
          },
          child: const Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
