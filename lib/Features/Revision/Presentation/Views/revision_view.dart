// revision_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/Features/Revision/Presentation/View_model/delete_card_cubit/delete_card_cubit.dart';
import 'package:smart_cards/Features/Revision/Presentation/Views/widgets/revision_view_body.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return BlocProvider(
      create: (context) => DeleteCardCubit(),
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

                // خيارات السبورة (تظهر فقط لما السبورة مفعلة)
                if (isWhiteboardEnabled) ...[
                  PopupMenuItem<String>(
                    value: 'clear_whiteboard',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, color: Colors.red),
                        SizedBox(width: 8.w),
                        Text(S.of(context).clearWhiteboard),
                      ],
                    ),
                  ),

                  /* PopupMenuItem<String>(
                    value: 'disable_whiteboard',
                    child: Row(
                      children:  [
                        Icon(Icons.close, color: Colors.grey),
                        SizedBox(width: 8),
                        Text(S.of(context).disableWhiteboard),
                      ],
                    ),
                  ),*/
                  PopupMenuItem<String>(
                    enabled: false,
                    value: 'color_header',
                    child: Text(
                      'Whiteboard color:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),

                  // قائمة الألوان
                  ...WhiteboardColors.colors.asMap().entries.map((entry) {
                    final index = entry.key;
                    final color = entry.value;
                    return PopupMenuItem<String>(
                      value: 'color_$index',
                      child: Row(
                        children: [
                          Container(
                            width: 24.w,
                            height: 24.w,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 1.w,
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(WhiteboardColors.getColorName(color)),
                        ],
                      ),
                    );
                  }),
                ],

                const PopupMenuDivider(),

                // حذف الكارت
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
                } /*else if (value == 'disable_whiteboard') {
                  setState(() {
                    isWhiteboardEnabled = false;
                  });
                }*/ else if (value.startsWith('color_')) {
                  final index = int.parse(value.split('_')[1]);
                  changeColorNotifier.value = WhiteboardColors.colors[index];
                } else if (value == 'delete_card') {
                  // نأكد من المستخدم قبل الحذف
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
        ),
      ),
    );
  }
}

class WhiteboardColors {
  static const List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.black,
    Colors.white,
  ];

  static String getColorName(Color color) {
    if (color == Colors.red) return 'Red';
    if (color == Colors.blue) return 'Blue';
    if (color == Colors.green) return 'Green';
    if (color == Colors.yellow) return 'Yellow';
    if (color == Colors.orange) return 'Orange';
    if (color == Colors.purple) return 'Purple';
    if (color == Colors.pink) return 'Pink';
    if (color == Colors.black) return 'Black';
    if (color == Colors.white) return 'White';
    return 'Color';
  }
}
