import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_cards/core/utils/network_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Data/models/collection_model.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/custom_delete_collection.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/custom_rename_collection.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/item_of_collections.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  @override
  void initState() {
    super.initState();
    context.read<GetCollectionsCubit>().getCollections();
  }

  @override
  Widget build(BuildContext context) {
    final stream = FirebaseFirestore.instance
        .collection('collections')
        .where('ownerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Check if we are offline
          return FutureBuilder<bool>(
            future: NetworkUtils.isOnline(),
            builder: (context, onlineSnapshot) {
              if (onlineSnapshot.connectionState == ConnectionState.done &&
                  onlineSnapshot.data == false) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.wifi_off, size: 64.sp, color: Colors.grey),
                      SizedBox(height: 16.h),
                      Text(
                        S.of(context).NoInternetConnection,
                        style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return const Center(child: CircularProgressIndicator());
            },
          );
        }

        final docs = snapshot.data?.docs ?? [];

        if (docs.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.folder_copy, size: 64.sp, color: Colors.grey),
                SizedBox(height: 16.h),
                Text(
                  S.of(context).NoCollectionsFound,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Convert documents to your model/entity
        final collections = docs
            .map((doc) => CollectionModel.fromDoc(doc))
            .toList();

        return ListView.builder(
          padding: EdgeInsets.all(16.r),
          itemCount: collections.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onLongPress: () {
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
                                  CustomDeleteCollection(
                                    collection: collections[index],
                                  ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },

              child: ItemOfCollections(collection: collections[index]),
            );
          },
        );
      },
    );
  }
}
