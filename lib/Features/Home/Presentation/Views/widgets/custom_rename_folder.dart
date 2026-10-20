import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/folder_entity.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/folder_cubit/actions_folder_cubit/actions_folder_cubit.dart';
import 'package:smart_cards/core/messages/message.dart';
import 'package:smart_cards/core/utils/helpers/network_utils.dart';
import 'package:smart_cards/core/views/widgets/app_dialog.dart';
import 'package:smart_cards/generated/l10n.dart';

class CustomRenameFolder extends StatefulWidget {
  const CustomRenameFolder({super.key, required this.folder});

  final FolderEntity folder;

  @override
  State<CustomRenameFolder> createState() => _CustomRenameFolderState();
}

class _CustomRenameFolderState extends State<CustomRenameFolder> {
  late final TextEditingController _controller;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.folder.name);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        S.of(context).renameFolder,
        style: TextStyle(fontSize: 15.sp),
      ),
      content: TextField(
        controller: _controller,
        autofocus: true,
        onChanged: (value) {
          final changed = value.trim() != widget.folder.name;
          setState(() => _isButtonEnabled = value.trim().isNotEmpty && changed);
        },
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: S.of(context).folderName,
          labelStyle: TextStyle(fontSize: 15.sp),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            S.of(context).cancel,
            style: const TextStyle(color: Colors.red),
          ),
        ),
        TextButton(
          onPressed: _isButtonEnabled
              ? () async {
                  if (!await NetworkUtils.isOnline()) {
                    if (context.mounted) {
                      Navigator.pop(context);
                      Message().showAppDialog(
                        context: context,
                        type: DialogType.error,
                        message: S.of(context).NoInternetConnection,
                      );
                      return;
                    }
                  }
                  if (!context.mounted) return;

                  context.read<ActionsFolderCubit>().renameFolder(
                        folderId: widget.folder.id,
                        newName: _controller.text.trim(),
                      );

                  Navigator.pop(context); // close rename dialog
                  Navigator.pop(context); // close SimpleDialog
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                _isButtonEnabled ? Colors.blueAccent : Colors.grey[700],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: Text(
            S.of(context).rename,
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
