import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/actions_collection_cubit/actions_collection_cubit.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';

class CustomRenameCollection extends StatefulWidget {
  const CustomRenameCollection({super.key, required this.collection});

  final CollectionEntity collection;

  @override
  State<CustomRenameCollection> createState() => _CustomRenameCollectionState();
}

class _CustomRenameCollectionState extends State<CustomRenameCollection> {
  late TextEditingController controller;
  bool isButtonEnabled = false;

  @override
  void initState() {
    controller = TextEditingController(text: widget.collection.collectionName);
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        S.of(context).renameCollection,
        style: TextStyle(fontSize: 15.sp),
      ),
      content: TextField(
        controller: controller,
        onChanged: (value) {
          setState(() => isButtonEnabled = value.trim().isNotEmpty);
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: S.of(context).collectionName,
          labelStyle: TextStyle(fontSize: 15.sp),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            S.of(context).cancel,
            style: TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: isButtonEnabled
              ? () {
                  context.read<ActionsCollectionCubit>().renameCollection(
                    collectionId: widget.collection.collection_id,
                    newName: controller.text,
                  );

                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: isButtonEnabled
                ? Colors.blueAccent
                : Colors.grey[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: Text(
            S.of(context).rename,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
