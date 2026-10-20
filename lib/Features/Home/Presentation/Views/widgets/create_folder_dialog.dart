import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Domain/Entities/collection_entity.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/actions_collection_cubit/actions_collection_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/folder_cubit/actions_folder_cubit/actions_folder_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/folder_cubit/actions_folder_cubit/actions_folder_states.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/folder_cubit/get_folders_cubit/get_folders_cubit.dart';
import 'package:smart_cards/core/messages/message.dart';
import 'package:smart_cards/core/views/widgets/custom_text_form_field.dart';
import 'package:smart_cards/generated/l10n.dart';

class CreateFolderDialog extends StatefulWidget {
  final CollectionEntity collectionToMove;

  const CreateFolderDialog({super.key, required this.collectionToMove});

  @override
  State<CreateFolderDialog> createState() => _CreateFolderDialogState();
}

class _CreateFolderDialogState extends State<CreateFolderDialog> {
  final GlobalKey<FormState> formKey = GlobalKey();
  final TextEditingController textEditingController = TextEditingController();
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return BlocListener<ActionsFolderCubit, ActionsFolderStates>(
      listener: (context, state) {
        if (state is AddFolderSuccess) {
          context.read<GetFoldersCubit>().getFolders(); // refresh locally
          // Folder created! Now move the collection to this new folder.
          context.read<ActionsCollectionCubit>().moveCollection(
            collectionId: widget.collectionToMove.collection_id,
            folderId: state.folderEntity.id,
          );
          Navigator.pop(context); // Close the dialog
          Message().showToastMessage(
            context: context,
            message: S.of(context).folderCreatedAndMovedSuccessfully,
            color: Colors.green,
          );
        } else if (state is ActionsFolderFailure) {
          Message().showToastMessage(
            context: context,
            message: state.errMessage,
            color: Colors.red,
          );
        }
      },
      child: AlertDialog(
        title: Text(S.of(context).newFolder.replaceAll("+ ", "")),
        content: Form(
          key: formKey,
          autovalidateMode: autovalidateMode,
          child: CustomTextFormField(
            controller: textEditingController,
            hintText: S.of(context).folderName,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return "Folder name cannot be empty";
              }
              return null;
            },
            onSaved: (value) {},
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(S.of(context).cancel),
          ),
          BlocBuilder<ActionsFolderCubit, ActionsFolderStates>(
            builder: (context, state) {
              if (state is ActionsFolderLoading) {
                return const CircularProgressIndicator();
              }
              return TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    context.read<ActionsFolderCubit>().addFolderMethod(
                      folderName: textEditingController.text.trim(),
                    );
                  } else {
                    setState(() {
                      autovalidateMode = AutovalidateMode.always;
                    });
                  }
                },
                child: Text(S.of(context).createAndMove),
              );
            },
          ),
        ],
      ),
    );
  }
}
