import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_states.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/create_collection.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/list_of_collections.dart';
import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/folder_cubit/get_folders_cubit/get_folders_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/folder_cubit/get_folders_cubit/get_folders_states.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  @override
  void initState() {
    context.read<GetCollectionsCubit>().getCollections();
    context.read<GetFoldersCubit>().getFolders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetFoldersCubit, GetFoldersStates>(
      builder: (context, folderState) {
        return BlocBuilder<GetCollectionsCubit, GetCollectionsStates>(
          builder: (context, collectionState) {
            if (collectionState is GetCollectionsLoading || folderState is GetFoldersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (collectionState is GetCollectionsFailure) {
              return Center(child: Text(collectionState.errMessage));
            } else if (folderState is GetFoldersFailure) {
              return Center(child: Text(folderState.errMessage));
            } else if (collectionState is GetCollectionsSuccess && folderState is GetFoldersSuccess) {
              final collections = collectionState.collections;
              final folders = folderState.folders;

              if (collections.isEmpty && folders.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    builder: (context) => const CreateCollectionDialog(),
                  );
                });
                return const SizedBox.shrink();
              }

              return ListOfCollections(
                collections: collections,
                folders: folders,
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
