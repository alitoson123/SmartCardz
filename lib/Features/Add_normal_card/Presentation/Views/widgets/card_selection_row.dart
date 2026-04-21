import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/widgets/custom_selection.dart';
import 'package:smart_cards/generated/l10n.dart';

class CardSelectionRow extends StatelessWidget {
  final String? selectedCollectionName;
  final String selectedType;
  final VoidCallback onTapCollection;
  final VoidCallback onTapType;

  const CardSelectionRow({
    super.key,
    required this.selectedCollectionName,
    required this.selectedType,
    required this.onTapCollection,
    required this.onTapType,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CustomSelection(
            label: selectedCollectionName ?? S.of(context).selectCollection,
            icon: Icons.collections_bookmark_rounded,
            onTap: onTapCollection,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: CustomSelection(
            label: selectedType,
            icon: Icons.style_rounded,
            onTap: onTapType,
          ),
        ),
      ],
    );
  }
}
