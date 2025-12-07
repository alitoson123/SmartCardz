import 'package:flutter/material.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';

class CustomDeleteCollection extends StatelessWidget {
  const CustomDeleteCollection({super.key, required this.collection});
  final CollectionEntity collection;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).deleteCollection),
      content: Text(S.of(context).deleteCollectionConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(S.of(context).cancel),
        ),
        TextButton(
          onPressed: () {
            AppServices.deleteCollection(
              collectionId: collection.collection_id,
            );
            Navigator.pop(context); // Close AlertDialog
            Navigator.pop(context); // Close SimpleDialog
          },
          child: Text(S.of(context).delete, style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
