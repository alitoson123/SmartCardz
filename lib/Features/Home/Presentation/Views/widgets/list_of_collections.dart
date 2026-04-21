import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collections_stats_cubit/collections_stats_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/custom_delete_collection.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/custom_rename_collection.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/item_of_collections.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/generated/l10n.dart';

class ListOfCollections extends StatelessWidget {
  const ListOfCollections({super.key, required this.collections});

  final List<CollectionEntity> collections;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => onRefresh(context),
      child: ListView.builder(
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
      ),
    );
  }

  void renameAndDeleteCollection(
    BuildContext context,
    List<CollectionEntity> collections,
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

  Future<void> onRefresh(BuildContext context) async {
    // Refresh collections from Firestore using Cubit (this gets rid of StreamBuilder)
    context.read<GetCollectionsCubit>().getCollections();

    // Collect all IDs to refresh their stats simultaneously
    final ids = collections.map((item) => item.collection_id).toList();

    // Capture the cubit before the await to be safe
    final cubit = context.read<CollectionsStatsCubit>();

    await cubit.refreshAll(ids);
  }
}
