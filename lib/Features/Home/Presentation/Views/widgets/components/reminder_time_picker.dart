import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReminderTimePicker extends StatelessWidget {
  final int hour;
  final String period;
  final ValueChanged<int?> onHourChanged;
  final ValueChanged<String?> onPeriodChanged;

  const ReminderTimePicker({
    super.key,
    required this.hour,
    required this.period,
    required this.onHourChanged,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _styledDropdown<int>(
            context: context,
            value: hour,
            items: List.generate(12, (i) => i + 1),
            onChanged: onHourChanged,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: _styledDropdown<String>(
            context: context,
            value: period,
            items: const ['AM', 'PM'],
            onChanged: onPeriodChanged,
          ),
        ),
      ],
    );
  }

  Widget _styledDropdown<T>({
    required BuildContext context,
    required T value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
  }) {
    final surfaceColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyLarge!.color!;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: textColor.withAlpha(30), width: 1),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          dropdownColor: surfaceColor,
          iconEnabledColor: textColor.withAlpha(160),
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(item is int ? '$item:00' : item.toString()),
                ),
              )
              .toList(),
          selectedItemBuilder: (_) => items
              .map(
                (item) => Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item is int ? '$item:00' : item.toString(),
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
