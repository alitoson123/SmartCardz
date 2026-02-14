import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Data/Models/collection_model.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/list_of_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/no_collection_widget.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  @override
  void initState() {
    context.read<GetCollectionsCubit>().getCollections();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('collections')
          .where('ownerId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
}
        final docs = snapshot.data?.docs ?? [];
        if (docs.isEmpty) {
          return noCollectionWidget();
        }

        final collections = docs
            .map((doc) => CollectionModel.fromDoc(doc))
            .toList();

        return ListOfCollections(collections: collections);
      },
    );
  }
}
