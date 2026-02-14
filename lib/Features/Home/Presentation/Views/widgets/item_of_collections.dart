import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ItemOfCollections extends StatelessWidget {
  const ItemOfCollections({super.key, required this.collection});
  final CollectionEntity collection;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey.shade200
                : Colors.white10,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 7.h, horizontal: 16.w),
          title: Text(
            collection.collectionName,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          subtitle: FutureBuilder<int>(
            future: countOfDueCards(),
            builder: (context, snapshot) {
              final dueCardsText = snapshot.hasData
                  ? '- ${snapshot.data} ${S.of(context).dueCards}'
                  : '- ... due';
              return Text(
                '${collection.cards_count} ${S.of(context).cards} $dueCardsText',
                style: TextStyle(fontSize: 14.sp),
              );
            },
          ),
          trailing: Icon(Icons.arrow_forward_ios, size: 18.sp),
          onTap: () {
            context.push(AppRoutes.revisionCardScreen, extra: collection);
          },
        ),
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
