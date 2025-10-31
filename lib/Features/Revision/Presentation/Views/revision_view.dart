import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/widgets/revision_view_body.dart';

class RevisionView extends StatelessWidget {
  const RevisionView({super.key,required this.collection});
  final CollectionEntity collection;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Revision',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: RevisionViewBody(collection: collection,),
    );
  }
}
