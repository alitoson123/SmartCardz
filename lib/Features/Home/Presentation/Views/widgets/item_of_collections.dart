import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 📁 presentation/views/widgets/item_of_collections.dart

import 'package:cloud_firestore/cloud_firestore.dart';

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
            future: _getCardCounts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text(
                  '${collection.cards_count} ${S.of(context).cards} - ...',
                  style: TextStyle(fontSize: 14.sp),
                );
              }

              if (!snapshot.hasData) {
                return Text(
                  '${collection.cards_count} ${S.of(context).cards}',
                  style: TextStyle(fontSize: 14.sp),
                );
              }

              final counts = snapshot.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.h),

                  // ── إجمالي الكروت ──
                  Text(
                    '${counts['total']} ${S.of(context).cards}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  // ── إحصائيات الكروت ──
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 4.h,
                    children: [
                      // Due Cards (المستحقة)
                      if (counts['due']! > 0)
                        _StatChip(
                          label: '${counts['due']} ${S.of(context).dueCards}',
                          color: Colors.red,
                          icon: Icons.notifications_active,
                        ),

                      // New Cards (جديدة)
                      if (counts['new']! > 0)
                        _StatChip(
                          label: '${counts['new']} جديد',
                          color: Colors.blue,
                          icon: Icons.fiber_new,
                        ),

                      // Learning Cards (بتتعلم)
                      if (counts['learning']! > 0)
                        _StatChip(
                          label: '${counts['learning']} تعلم',
                          color: Colors.orange,
                          icon: Icons.school,
                        ),

                      // Review Cards (مراجعة)
                      if (counts['review']! > 0)
                        _StatChip(
                          label: '${counts['review']} مراجعة',
                          color: Colors.green,
                          icon: Icons.check_circle,
                        ),

                      // Relearning Cards (إعادة تعلم)
                      if (counts['relearning']! > 0)
                        _StatChip(
                          label: '${counts['relearning']} إعادة',
                          color: Colors.purple,
                          icon: Icons.replay,
                        ),
                    ],
                  ),
                ],
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

  Future<Map<String, int>> _getCardCounts() async {
    return await AppServices2.getCardStateCounts(
      collectionId: collection.collection_id,
    );
  }
}

// ══════════════════════════════════════════════════
//   Stat Chip Widget
// ══════════════════════════════════════════════════
class _StatChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _StatChip({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class AppServices2 {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ══════════════════════════════════════════════════
  ///   عدد الكروت المستحقة (Due Cards)
  /// ══════════════════════════════════════════════════
  static Future<int> countOfDueCards({required String collectionId}) async {
    final now = Timestamp.now();

    final snapshot = await _firestore
        .collection('cards')
        .where('collectionId', isEqualTo: collectionId)
        .where('due_date', isLessThanOrEqualTo: now)
        .count()
        .get();

    return snapshot.count ?? 0;
  }

  /// ══════════════════════════════════════════════════
  ///   عدد الكروت الجديدة (New Cards)
  /// ══════════════════════════════════════════════════
  static Future<int> countOfNewCards({required String collectionId}) async {
    final snapshot = await _firestore
        .collection('cards')
        .where('collectionId', isEqualTo: collectionId)
        .where('state', isEqualTo: 'newCard')
        .count()
        .get();

    return snapshot.count ?? 0;
  }

  /// ══════════════════════════════════════════════════
  ///   عدد الكروت في مرحلة التعلم (Learning Cards)
  /// ══════════════════════════════════════════════════
  static Future<int> countOfLearningCards({
    required String collectionId,
  }) async {
    final snapshot = await _firestore
        .collection('cards')
        .where('collectionId', isEqualTo: collectionId)
        .where('state', isEqualTo: 'learning')
        .count()
        .get();

    return snapshot.count ?? 0;
  }

  /// ══════════════════════════════════════════════════
  ///   عدد الكروت في المراجعة (Review Cards)
  /// ══════════════════════════════════════════════════
  static Future<int> countOfReviewCards({required String collectionId}) async {
    final snapshot = await _firestore
        .collection('cards')
        .where('collectionId', isEqualTo: collectionId)
        .where('state', isEqualTo: 'review')
        .count()
        .get();

    return snapshot.count ?? 0;
  }

  /// ══════════════════════════════════════════════════
  ///   عدد الكروت في إعادة التعلم (Relearning Cards)
  /// ══════════════════════════════════════════════════
  static Future<int> countOfRelearningCards({
    required String collectionId,
  }) async {
    final snapshot = await _firestore
        .collection('cards')
        .where('collectionId', isEqualTo: collectionId)
        .where('state', isEqualTo: 'relearning')
        .count()
        .get();

    return snapshot.count ?? 0;
  }

  /// ══════════════════════════════════════════════════
  ///   عدد كل الأنواع في مرة واحدة (أسرع)
  /// ══════════════════════════════════════════════════
  static Future<Map<String, int>> getCardStateCounts({
    required String collectionId,
  }) async {
    // جيب كل الكروت مرة واحدة
    final snapshot = await _firestore
        .collection('cards')
        .where('collectionId', isEqualTo: collectionId)
        .get();

    int newCount = 0;
    int learningCount = 0;
    int reviewCount = 0;
    int relearningCount = 0;
    int dueCount = 0;

    final now = DateTime.now();

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final state = data['state'] as String?;
      final dueDate = (data['due_date'] as Timestamp?)?.toDate();

      // عدد حسب الـ state
      switch (state) {
        case 'newCard':
          newCount++;
          break;
        case 'learning':
          learningCount++;
          break;
        case 'review':
          reviewCount++;
          break;
        case 'relearning':
          relearningCount++;
          break;
      }

      // عدد المستحقة
      if (dueDate != null && dueDate.isBefore(now)) {
        dueCount++;
      }
    }

    return {
      'new': newCount,
      'learning': learningCount,
      'review': reviewCount,
      'relearning': relearningCount,
      'due': dueCount,
      'total': snapshot.docs.length,
    };
  }
}
