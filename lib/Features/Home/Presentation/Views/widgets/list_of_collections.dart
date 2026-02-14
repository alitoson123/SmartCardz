import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Home/Data/Models/collection_model.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/custom_delete_collection.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/custom_rename_collection.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/item_of_collections.dart';
import 'package:smart_cards/generated/l10n.dart';

class ListOfCollections extends StatelessWidget {
  const ListOfCollections({super.key, required this.collections});

 final List<CollectionModel> collections;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16.r),
      itemCount: collections.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onLongPress: () {
            renameAndDeleteCollection(context, collections, index);
          },

          child: ItemOfCollections(collection: collections[index]),
        );
      },
    );
  }

  void renameAndDeleteCollection(
    BuildContext context,
    List<CollectionModel> collections,
    int index,
  ) {
    showDialog(
      context: context,
      builder: (simpleDialogContext) {
        return SimpleDialog(
          title: Text(collections[index].collectionName),
          children: [

            SimpleDialogOption(
              child: Text(S.of(context).renameCollection),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CustomRenameCollection(
                      collection: collections[index],
                    );
                  },
                );
              },
            ),

            SimpleDialogOption(
              child: Text(S.of(context).deleteCollection),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialogContext) =>
                      CustomDeleteCollection(collection: collections[index]),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
