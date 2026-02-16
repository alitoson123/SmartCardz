import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_states.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/core/views/widgets/cancel_widget.dart';
import 'package:smart_cards/core/views/widgets/collection_item.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:smart_cards/core/views/widgets/selection_search_field.dart';

class CollectionView extends StatefulWidget {
  const CollectionView({super.key});

  @override
  State<CollectionView> createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  final TextEditingController searchController = TextEditingController();
  List<CollectionEntity> allCollections = []; // all collections
  List<CollectionEntity> filteredCollections = []; // filtered collections

  @override
  void initState() {
    super.initState();
    context.read<GetCollectionsCubit>().getCollections();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(S.of(context).searchCollectionTitle),
      ),
      body: BlocConsumer<GetCollectionsCubit, GetCollectionsStates>(
        listener: (context, state) {
          if (state is GetCollectionsSuccess) {
            setState(() {
              allCollections = state.collections;
              filteredCollections = state.collections;
            });
          }
        },
        builder: (context, state) {
          if (state is GetCollectionsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetCollectionsFailure) {
            return Center(child: Text(state.errMessage));
          }
          return Column(
            children: [
              // search Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: SelectionSearchField(
                  searchController: searchController,
                  onChanged: filterCollections,
                ),
              ),
              // collections list
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  itemCount: filteredCollections.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    final collection = filteredCollections[index];
                    final name = collection.collectionName;

                    return CollectionItem(
                      collection: collection,
                      onTap: () {
                        Navigator.pop(context, {
                          'id': collection.collection_id,
                          'name': name,
                        });
                      },
                    );
                  },
                ),
              ),
              // cancel button
              const CancelWidget(),
            ],
          );
        },
      ),
    );
  }

  // filter collections (Search Function)
  void filterCollections(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredCollections = allCollections;
      } else {
        filteredCollections = allCollections.where((collection) {
          final name = collection.collectionName.toLowerCase();
          final search = query.toLowerCase();
          return name.contains(search);
        }).toList();
      }
    });
  }
}
