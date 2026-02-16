import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/generated/l10n.dart';

class SelectionSearchField extends StatelessWidget {
  const SelectionSearchField({
    super.key,
    required this.searchController,
    required this.onChanged,
  });

  final TextEditingController searchController;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(.5),
                  blurRadius: 2,
                  offset: const Offset(0, 2),
                ),
              ],
        border: isDark ? Border.all(color: Colors.white10) : null,
      ),
      child: TextField(
        controller: searchController,
        onChanged: onChanged,
        style: TextStyle(
          color: theme.textTheme.bodyLarge?.color ?? Colors.black87,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: theme.hintColor),
          hintText: S.of(context).searchCollectionHint,
          hintStyle: TextStyle(color: theme.hintColor, fontSize: 14.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
      ),
    );
  }
}
