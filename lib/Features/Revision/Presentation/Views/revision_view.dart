import 'package:flutter/material.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/widgets/revision_view_body.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collections_stats_cubit/collections_stats_cubit.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/revision_cubit/recision_cubit.dart';

class RevisionView extends StatefulWidget {
  const RevisionView({super.key, required this.collection});
  final CollectionEntity collection;

  @override
  State<RevisionView> createState() => _RevisionViewState();
}

class _RevisionViewState extends State<RevisionView> {
  bool isWhiteboardEnabled = false;
  final ValueNotifier<bool> deleteCardNotifier = ValueNotifier(false);
  final ValueNotifier<bool> clearWhiteboardNotifier = ValueNotifier(false);
  final ValueNotifier<bool> editCardNotifier = ValueNotifier(false);
  final ValueNotifier<Color?> changeColorNotifier = ValueNotifier(null);

  @override
  void dispose() {
    deleteCardNotifier.dispose();
    clearWhiteboardNotifier.dispose();
    changeColorNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Capture cubits before the widget unmounts
    final statsCubit = context.read<CollectionsStatsCubit>();
    final revisionCubit = context.read<RevisionCubit>();
    final collectionId = widget.collection.collection_id;

    return PopScope(
      // 2. Allow normal fast back navigation (UI doesn't freeze)
      canPop: true,
      // 3. When the user tries to escape the screen
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        // If it didn't pop for some reason, ignore.
        if (!didPop) return;

        // Execute sequentially in the background WITHOUT freezing the UI
        Future(() async {
          // A) Force RevisionCubit to save any pending cards to Firestore
          await revisionCubit.saveModifiedCards();

          // B) Now fetch the fresh stats
          await statsCubit.forceRefreshCollection(collectionId);
        });
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).revisionTitle),
          actions: [
            PopupMenuButton<String>(
              itemBuilder: (context) => [
                // Enable/Disable Whiteboard
                PopupMenuItem<String>(
                  value: 'toggle_whiteboard',
                  child: Row(
                    children: [
                      Icon(
                        isWhiteboardEnabled
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: isWhiteboardEnabled ? Colors.blue : Colors.grey,
                      ),
                      SizedBox(width: 8.w),
                      Text(S.of(context).enableDisableWhiteboard),
                    ],
                  ),
                ),

                PopupMenuItem<String>(
                  value: 'edit_card',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: Colors.blue),
                      SizedBox(width: 8.w),
                      Text(S.of(context).editCard),
                    ],
                  ),
                ),
                // خيارات السبورة (تظهر فقط لما السبورة مفعلة)
                if (isWhiteboardEnabled) ...[
                  // clear whiteboard
                  PopupMenuItem<String>(
                    value: 'clear_whiteboard',
                    child: Row(
                      children: [
                        Icon(
                          Icons.cleaning_services_rounded,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 8.w),
                        Text(S.of(context).clearWhiteboard),
                      ],
                    ),
                  ),

                  // color header
                  PopupMenuItem<String>(
                    enabled: false,
                    value: 'color_header',
                    child: Text(
                      S.of(context).whiteboardColor,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),

                  // Colors list

                  // بتحول الـ List لـ Map، المفتاح هو الـ index والقيمة هي العنص
                  //   {0: Colors.red, 1: Colors.blue, 2: Colors.green, ...}
                  //بيمشي على كل عنصر في الـ Map ويجيب الـ index واللون مع بعض.
                  ...WhiteboardColors.colors.asMap().entries.map((item) {
                    final index = item.key;
                    final color = item.value;
                    return PopupMenuItem<String>(
                      value: 'color_$index',
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey.shade400,
                            radius: 14.r,
                            child: CircleAvatar(
                              backgroundColor: color,
                              radius: 13.r,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(WhiteboardColors.getColorName(context, color)),
                        ],
                      ),
                    );
                  }),
                ],

                const PopupMenuDivider(),

                // delete card
                PopupMenuItem<String>(
                  value: 'delete_card',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8.w),
                      Text(S.of(context).deleteCardMenu),
                    ],
                  ),
                ),
              ],
              onSelected: (value) {
                if (value == 'toggle_whiteboard') {
                  setState(() {
                    isWhiteboardEnabled = !isWhiteboardEnabled;
                  });
                } else if (value == 'clear_whiteboard') {
                  clearWhiteboardNotifier.value =
                      !clearWhiteboardNotifier.value;
                } else if (value == 'edit_card') {
                  // Disable the whiteboard before opening the edit dialog
                  // to prevent accidental drawing on top of the modal.
                  if (isWhiteboardEnabled) {
                    setState(() => isWhiteboardEnabled = false);
                  }
                  editCardNotifier.value = !editCardNotifier.value;
                } else if (value.startsWith('color_')) {
                  final index = int.parse(value.split('_')[1]);
                  // string to list [color,index]
                  changeColorNotifier.value = WhiteboardColors.colors[index];
                  // put the color into  changeColorNotifier.value
                } else if (value == 'delete_card') {
                  // confirm delete card
                  showDialog(
                    context: context,
                    builder: (dialogContext) => AlertDialog(
                      title: Text(S.of(context).deleteCard),
                      content: Text(S.of(context).deleteCardConfirm),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(S.of(context).cancel),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(dialogContext);
                            deleteCardNotifier.value =
                                !deleteCardNotifier.value;
                          },
                          child: Text(
                            S.of(context).delete,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
          ],
        ),
        body: RevisionViewBody(
          collection: widget.collection,
          isWhiteboardEnabled: isWhiteboardEnabled,
          clearWhiteboardNotifier: clearWhiteboardNotifier,
          changeColorNotifier: changeColorNotifier,
          deleteCardNotifier: deleteCardNotifier,
          editCardNotifier: editCardNotifier,
        ),
      ),
    );
  }
}
