import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/folder_entity.dart';

class FolderItemWidget extends StatelessWidget {
  final FolderEntity folder;
  final bool isExpanded;
  final int collectionCount;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const FolderItemWidget({
    super.key,
    required this.folder,
    required this.isExpanded,
    required this.collectionCount,
    required this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14.r),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Colored accent strip ───────────────────────────────────
                Container(
                  width: 4.w,
                  color: colorScheme.primary,
                ),

                // ── Content ────────────────────────────────────────────────
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 14.h,
                    ),
                    child: Row(
                      children: [
                        // Folder icon
                        Icon(
                          isExpanded
                              ? Icons.folder_open_rounded
                              : Icons.folder_rounded,
                          color: colorScheme.primary,
                          size: 26.sp,
                        ),
                        SizedBox(width: 12.w),

                        // Name + count
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                folder.name,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.sp,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                '$collectionCount ${collectionCount == 1 ? "collection" : "collections"}',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: colorScheme.onSurface
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Chevron
                        AnimatedRotation(
                          turns: isExpanded ? 0.25 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.chevron_right_rounded,
                            color: colorScheme.onSurface.withValues(alpha: 0.4),
                            size: 20.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
