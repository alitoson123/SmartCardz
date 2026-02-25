import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:smart_cards/core/services/app_services/app_services.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 📁 presentation/views/widgets/item_of_collections.dart

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
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 16.w,
          ),
          title: Text(
            collection.collectionName,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          subtitle: FutureBuilder<Map<String, int>>(
            future: AppServices.getCardStateCounts(
              collectionId: collection.collection_id,
            ),
            builder: (context, snapshot) {
              // ── Loading ──
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Text(
                    '${collection.cards_count} ${S.of(context).cards}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                );
              }

              // ── Error / No data ──
              if (!snapshot.hasData) {
                return Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Text(
                    '${collection.cards_count} ${S.of(context).cards}',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                );
              }

              final counts = snapshot.data!;
              final totalDue = counts['due']!;

              // ✅ كل حاجة في سطر واحد
              return Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── عدد الكروت ──
                    Text(
                      '${counts['total']} ${S.of(context).cards}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    // ── فاصل ──
                    if (totalDue > 0) ...[
                      // ── نقطة amber + عدد due ──
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Container(
                          width: 7.w,
                          height: 7.w,
                          decoration: const BoxDecoration(
                            color: Colors.amber,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      // SizedBox(width: 4.w),
                      Text(
                        '${totalDue} ${S.of(context).due}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.amber,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],

                    // ── لو مفيش due ──
                    if (totalDue == 0) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 14.sp,
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
                      //SizedBox(width: 3.w),
                      Text(
                        S.of(context).all_done,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF4CAF50),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
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
}


