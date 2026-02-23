import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/title_of_dialog.dart';
import 'package:smart_cards/core/utils/helpers/network_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/add_collection_cubit1.dart/add_collection_cubit.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateCollectionDialog extends StatefulWidget {
  const CreateCollectionDialog({super.key});

  @override
  State<CreateCollectionDialog> createState() => _CreateCollectionDialogState();
}

class _CreateCollectionDialogState extends State<CreateCollectionDialog> {
  final TextEditingController controller = TextEditingController();
  bool isButtonEnabled = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final themeColors = Theme.of(context).colorScheme;

    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.all(16.r),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      backgroundColor: themeColors.surface,
      title: TitleOfDialog(themeColors: themeColors),
      content: contentOfDialog(context),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            S.of(context).cancel,
            style: TextStyle(color: Colors.grey),
          ),
        ),
        ElevatedButton(
          onPressed: isButtonEnabled && !isLoading
              ? () => createCollection(context)
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isButtonEnabled
                ? Colors.blueAccent
                : Colors.grey[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
          ),
          child: isLoading
              ? SizedBox(
                  height: 20.h,
                  width: 20.w,
                  child: CircularProgressIndicator(strokeWidth: 2.w),
                )
              : Text(
                  S.of(context).create,
                  style: TextStyle(color: Colors.white),
                ),
        ),
      ],
    );
  }

  Widget contentOfDialog(BuildContext context) {
    return SizedBox(
      width: 0.75.sw,
      child: TextField(
        cursorColor: Colors.blueAccent,
        controller: controller,
        autofocus: true,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          focusColor: Colors.blueAccent,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blueAccent),
            borderRadius: BorderRadius.circular(10.r),
          ),
          hintText: S.of(context).enterCollectionName,
          hintStyle: TextStyle(color: Colors.grey[400]),
          filled: true,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        onChanged: (value) {
          setState(() => isButtonEnabled = value.trim().isNotEmpty);
        },
      ),
    );
  }

  void createCollection(BuildContext context) async {
    if (!await NetworkUtils.isOnline()) {
      // check if the device is online
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).NoInternetConnection),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    setState(() => isLoading = true); // set loading state = true

    context.read<AddCollectionCubit>().addCollectionMethod(
      // call add collection cubit
      collectionName: controller.text.trim(),
    );

    Navigator.pop(context); // close dialog

    setState(() => isLoading = false); // set loading state = false
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
