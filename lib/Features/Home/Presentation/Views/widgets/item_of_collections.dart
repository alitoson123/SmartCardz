import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/core/utils/routes.dart';

class ItemOfCollections extends StatelessWidget {
  const ItemOfCollections({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 16,
        ),
        title: Text(
          'English Vocabulary',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: Text('120 cards'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          context.push(AppRoutes.revisionCardScreen);
        },
      ),
    );
  }
}
