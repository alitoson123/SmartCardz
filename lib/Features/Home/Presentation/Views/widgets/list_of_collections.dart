import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/folder_entity.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/home_item_entity.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collections_stats_cubit/collections_stats_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/folder_cubit/actions_folder_cubit/actions_folder_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/folder_cubit/actions_folder_cubit/actions_folder_states.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/folder_cubit/get_folders_cubit/get_folders_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/custom_delete_collection.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/custom_delete_folder.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/custom_rename_collection.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/custom_rename_folder.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/item_of_collections.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/folder_item_widget.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/move_collection_bottom_sheet.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/core/messages/message.dart';
import 'package:smart_cards/core/utils/helpers/network_utils.dart';
import 'package:smart_cards/core/views/widgets/app_dialog.dart';
import 'package:smart_cards/generated/l10n.dart';

class ListOfCollections extends StatefulWidget {
  const ListOfCollections({
    super.key,
    required this.collections,
    required this.folders,
  });

  final List<CollectionEntity> collections;
  final List<FolderEntity> folders;

  @override
  State<ListOfCollections> createState() => _ListOfCollectionsState();
}

class _ListOfCollectionsState extends State<ListOfCollections> {
  final Set<String> expandedFolders = {};

  void _toggleFolder(String folderId) {
    setState(() {
      if (expandedFolders.contains(folderId)) {
        expandedFolders.remove(folderId);
      } else {
        expandedFolders.add(folderId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Separate collections into root collections and folder collections
    final rootCollections =
        widget.collections.where((c) => c.folder_id == null).toList();

    // 2. Sort folders by createdAt
    final sortedFolders = List<FolderEntity>.from(widget.folders)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // 3. Sort root collections by createdAt
    final sortedRootCollections = List<CollectionEntity>.from(rootCollections)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // 4. Build the flattened list based on expanded folders
    final List<HomeItemEntity> displayItems = [];

    for (final folder in sortedFolders) {
      displayItems.add(folder);
      if (expandedFolders.contains(folder.id)) {
        final folderCollections = widget.collections
            .where((c) => c.folder_id == folder.id)
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
        displayItems.addAll(folderCollections);
      }
    }

    // Add root collections after folders
    displayItems.addAll(sortedRootCollections);

    return BlocListener<ActionsFolderCubit, ActionsFolderStates>(
      listener: (context, state) {
        if (state is RenameFolderSuccess) {
          context.read<GetFoldersCubit>().renameFolderLocally(
                state.folderId,
                state.folderName,
              );
          Message().MessageSuccessMethod(
            context,
            message: S.of(context).folderRenamedSuccessfully,
            duration: const Duration(milliseconds: 400),
          );
        } else if (state is DeleteFolderSuccess) {
          // Remove the folder and unassign its collections locally
          context.read<GetFoldersCubit>().removeFolderLocally(state.folderId);
          context
              .read<GetCollectionsCubit>()
              .unassignFolderLocally(state.folderId);
          Message().MessageSuccessMethod(
            context,
            message: S.of(context).folderDeletedSuccessfully,
            duration: const Duration(milliseconds: 400),
          );
        } else if (state is ActionsFolderFailure) {
          Message().showAppDialog(
            context: context,
            type: DialogType.error,
            message: state.errMessage,
          );
        }
      },
      child: RefreshIndicator(
        onRefresh: () => _onRefresh(context),
        child: ListView.builder(
          padding: EdgeInsets.all(16.r),
          itemCount: displayItems.length,
          itemBuilder: (context, index) {
            final item = displayItems[index];

            if (item is FolderEntity) {
              final count = widget.collections
                  .where((c) => c.folder_id == item.id)
                  .length;
              return FolderItemWidget(
                folder: item,
                isExpanded: expandedFolders.contains(item.id),
                collectionCount: count,
                onTap: () => _toggleFolder(item.id),
                onLongPress: () => _showFolderOptions(context, item),
              );
            } else if (item is CollectionEntity) {
              return GestureDetector(
                onLongPress: () {
                  _showCollectionOptions(context, item);
                },
                child: Padding(
                  padding: EdgeInsets.only(
                    left: item.folder_id != null ? 32.w : 0,
                  ),
                  child: ItemOfCollections(collection: item),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  // ── Folder context menu ────────────────────────────────────────────────────

  void _showFolderOptions(BuildContext context, FolderEntity folder) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return SimpleDialog(
          title: Text(folder.name),
          children: [
            SimpleDialogOption(
              child: Text(S.of(context).renameFolder),
              onPressed: () {
                Navigator.pop(dialogContext);
                showDialog(
                  context: context,
                  builder: (_) => CustomRenameFolder(folder: folder),
                );
              },
            ),
            SimpleDialogOption(
              child: Text(
                S.of(context).deleteFolder,
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
                showDialog(
                  context: context,
                  builder: (_) => CustomDeleteFolder(folder: folder),
                );
              },
            ),
          ],
        );
      },
    );
  }

  // ── Collection context menu ────────────────────────────────────────────────

  void _showCollectionOptions(BuildContext context, CollectionEntity collection) {
    showDialog(
      context: context,
      builder: (simpleDialogContext) {
        return SimpleDialog(
          title: Text(collection.collectionName),
          children: [
            SimpleDialogOption(
              child: Text(S.of(context).renameCollection),
              onPressed: () {
                Navigator.pop(simpleDialogContext);
                showDialog(
                  context: context,
                  builder: (_) =>
                      CustomRenameCollection(collection: collection),
                );
              },
            ),
            SimpleDialogOption(
              child: Text(S.of(context).moveCollection),
              onPressed: () {
                Navigator.pop(simpleDialogContext);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) =>
                      MoveCollectionBottomSheet(collection: collection),
                );
              },
            ),
            SimpleDialogOption(
              child: Text(S.of(context).deleteCollection),
              onPressed: () {
                Navigator.pop(simpleDialogContext);
                showDialog(
                  context: context,
                  builder: (_) =>
                      CustomDeleteCollection(collection: collection),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _onRefresh(BuildContext context) async {
    if (!await NetworkUtils.isOnline()) {
      if (context.mounted) {
        Message().showAppDialog(
          context: context,
          type: DialogType.error,
          message: S.of(context).NoInternetConnection,
        );
      }
      return;
    }

    context.read<GetCollectionsCubit>().getCollections();
    context.read<GetFoldersCubit>().getFolders();

    final ids =
        widget.collections.map((item) => item.collection_id).toList();
    await context.read<CollectionsStatsCubit>().refreshAll(ids);
  }
}
