import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/core/view_model/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/core/view_model/get_collections_cubit/get_collections_states.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';

class CollectionView extends StatefulWidget {
  const CollectionView({super.key});

  @override
  State<CollectionView> createState() => _CollectionViewState();
}

class _CollectionViewState extends State<CollectionView> {
  final TextEditingController searchController = TextEditingController();
  List<CollectionEntity> collections = [];

  @override
  void initState() {
    super.initState();
    context.read<GetCollectionsCubit>().getCollections();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search for a collection'),
        backgroundColor: Colors.blue,
      ),
      body: BlocBuilder<GetCollectionsCubit, GetCollectionsStates>(
        builder: (context, state) {
          if (state is GetCollectionsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetCollectionsSuccess) {
            collections = state.collections;
          } else if (state is GetCollectionsFailure) {
            return Center(child: Text(state.errMessage));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search for a collection...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: collections.length,
                  itemBuilder: (context, index) {
                    final collection = collections[index];
                    final name = collection.collectionName;
                    log(name);
                    // 🔎 البحث
                    if (searchController.text.isNotEmpty &&
                        !name.toLowerCase().contains(
                          searchController.text.toLowerCase(),
                        )) {
                      return const SizedBox();
                    }

                    return ListTile(
                      title: Text(name),
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
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      ),
    );
  }
}
