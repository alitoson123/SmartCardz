import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/folder_entity.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/folder_cubit/actions_folder_cubit/actions_folder_cubit.dart';
import 'package:smart_cards/core/messages/message.dart';
import 'package:smart_cards/core/utils/helpers/network_utils.dart';
import 'package:smart_cards/core/views/widgets/app_dialog.dart';
import 'package:smart_cards/generated/l10n.dart';

class CustomDeleteFolder extends StatelessWidget {
  const CustomDeleteFolder({super.key, required this.folder});

  final FolderEntity folder;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(S.of(context).deleteFolder),
      content: Text(S.of(context).deleteFolderConfirm),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(S.of(context).cancel),
        ),
        TextButton(
          onPressed: () async {
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

            context.read<ActionsFolderCubit>().deleteFolder(
                  folderId: folder.id,
                );

            Navigator.pop(context); // close delete dialog
            Navigator.pop(context); // close SimpleDialog
          },
          child: Text(
            S.of(context).delete,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}
