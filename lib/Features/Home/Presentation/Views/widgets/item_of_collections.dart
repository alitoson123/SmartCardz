import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';
import 'package:smart_cards/generated/l10n.dart';

class ItemOfCollections extends StatelessWidget {
  const ItemOfCollections({super.key, required this.collection});
  final CollectionEntity collection;

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
          collection.collectionName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: FutureBuilder<int>(
          future: countOfDueCards(),
          builder: (context, snapshot) {
            final dueCardsText = snapshot.hasData
                ? '- ${snapshot.data} due'
                : '- ...';
            return Text(
              '${collection.cards_count} ${S.of(context).cards} $dueCardsText',
            );
          },
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18),
        onTap: () {
          context.push(AppRoutes.revisionCardScreen, extra: collection);
        },
      ),
    );
  }

  Future<int> countOfDueCards() async {
    final count = await AppServices.countOfDueCards(
      collectionId: collection.collection_id,
    );
    log(count.toString());
    return count;
  }
}
