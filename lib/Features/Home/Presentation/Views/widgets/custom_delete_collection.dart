import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/delete_collection_cubit.dart/delete_collection_cubit.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';

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
            context.read<DeleteCollectionCubit>().deleteCollection(
              collectionId: collection.collection_id,
            );

            Navigator.pop(context); // Close AlertDialog
            Navigator.pop(context); // Close SimpleDialog
          },
          child: Text(
            S.of(context).delete,
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
