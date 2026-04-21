import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collections_stats_cubit/collections_stats_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collections_stats_cubit/collections_stats_states.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class ItemOfCollections extends StatefulWidget {
  const ItemOfCollections({super.key, required this.collection});
  final CollectionEntity collection;

  @override
  State<ItemOfCollections> createState() => _ItemOfCollectionsState();
}

class _ItemOfCollectionsState extends State<ItemOfCollections> {
  @override
  void initState() {
    super.initState();
    context.read<CollectionsStatsCubit>().getStatsForCollection(widget.collection.collection_id);
  }

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
            widget.collection.collectionName,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
          subtitle: BlocBuilder<CollectionsStatsCubit, CollectionsStatsState>(
            builder: (context, state) {
              int total = widget.collection.cards_count;
              int due = 0;
              bool isLoading = true;

              if (state is CollectionsStatsSuccess) {
                // If we have success state, check if our collection ID is in the map
                if (state.statsMap.containsKey(widget.collection.collection_id)) {
                  final stats = state.statsMap[widget.collection.collection_id]!;
                  total = stats.totalCards;
                  due = stats.dueCards;
                  isLoading = false;
                }
              } else if (state is CollectionsStatsFailure) {
                isLoading = false;
              }

              if (isLoading) {
                return Padding(
                  padding: EdgeInsets.only(top: 6.h),
                  child: Text(
                    '$total ${S.of(context).cards}...',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade500,
                    ),
                  ),
                );
              }

              // ── Data Loaded ──
              return Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Total Cards Count ──
                    Text(
                      '$total ${S.of(context).cards}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    // ── If there are Due Cards ──
                    if (due > 0) ...[
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
                      Text(
                        '$due ${S.of(context).due}',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.amber,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],

                    // ── If all Due Cards are done ──
                    if (due == 0 && total > 0) ...[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.w),
                        child: Icon(
                          Icons.check_circle_rounded,
                          size: 14.sp,
                          color: const Color(0xFF4CAF50),
                        ),
                      ),
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
            context.push(AppRoutes.revisionCardScreen, extra: widget.collection);
          },
        ),
      ),
    );
  }
}
