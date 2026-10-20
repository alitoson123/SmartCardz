import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/actions_collection_cubit/actions_collection_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/actions_collection_cubit/actions_collection_states.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/folder_cubit/get_folders_cubit/get_folders_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/folder_cubit/get_folders_cubit/get_folders_states.dart';
import 'package:smart_cards/core/messages/message.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/create_folder_dialog.dart';

class MoveCollectionBottomSheet extends StatelessWidget {
  final CollectionEntity collection;

  const MoveCollectionBottomSheet({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<ActionsCollectionCubit, ActionsCollectionStates>(
      listener: (context, state) {
        if (state is MoveCollectionSuccess) {
          // Update the in-memory list instantly — no network round-trip needed.
          context.read<GetCollectionsCubit>().moveCollectionLocally(
                state.collectionId,
                state.folderId,
              );
          Navigator.pop(context); // Close bottom sheet
          Message().showToastMessage(
            context: context,
            message: S.of(context).folderCreatedAndMovedSuccessfully,
            color: Colors.green,
          );
        } else if (state is ActionsCollectionFailure) {
          Message().showToastMessage(
            context: context,
            message: state.errMessage,
            color: Colors.red,
          );
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                S.of(context).moveToFolder,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16.h),
            
            // + New Folder Option
            ListTile(
              leading: Icon(Icons.create_new_folder, color: theme.primaryColor),
              title: Text(
                S.of(context).newFolder,
                style: TextStyle(color: theme.primaryColor, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => CreateFolderDialog(collectionToMove: collection),
                );
              },
            ),
            Divider(height: 1),
            
            // Remove from Folder (if it's already in one)
            if (collection.folder_id != null) ...[
              ListTile(
                leading: const Icon(Icons.drive_file_move_rtl),
                title: Text(S.of(context).removeFromFolder),
                onTap: () {
                  context.read<ActionsCollectionCubit>().moveCollection(
                        collectionId: collection.collection_id,
                        folderId: null, // Move to root
                      );
                },
              ),
              Divider(height: 1),
            ],

            // Existing Folders
            BlocBuilder<GetFoldersCubit, GetFoldersStates>(
              builder: (context, state) {
                if (state is GetFoldersSuccess) {
                  final folders = state.folders;
                  if (folders.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Center(child: Text(S.of(context).noFoldersYet)),
                    );
                  }
                  
                  return Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: folders.length,
                      itemBuilder: (context, index) {
                        final folder = folders[index];
                        // Don't show the folder it's already in
                        if (folder.id == collection.folder_id) return const SizedBox.shrink();
                        
                        return ListTile(
                          leading: const Icon(Icons.folder),
                          title: Text(folder.name),
                          onTap: () {
                            context.read<ActionsCollectionCubit>().moveCollection(
                              collectionId: collection.collection_id,
                              folderId: folder.id,
                            );
                          },
                        );
                      },
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}
