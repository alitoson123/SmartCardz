import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_text_field.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/View_model/normal_card_cubit/normal_card_cubit.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/widgets/camera_or_gallery_dialog.dart';
import 'package:smart_cards/core/utils/widgets/app_button.dart';
import 'package:smart_cards/core/utils/widgets/app_header.dart';
import 'package:smart_cards/core/view_model/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/core/views/collection_view.dart';
import 'package:smart_cards/generated/l10n.dart';

class AddNormalCardViewBody extends StatefulWidget {
  const AddNormalCardViewBody({super.key});

  @override
  State<AddNormalCardViewBody> createState() => _AddNormalCardViewBodyState();
}

class _AddNormalCardViewBodyState extends State<AddNormalCardViewBody> {
  final TextEditingController frontSideController = TextEditingController();
  final TextEditingController backSideController = TextEditingController();

  String? selectedCollectionName;
  String? selectedCollectionId;

  File? frontImage;
  File? backImage;
  File? image;

  Future<File?> pickImageFromGallery() async {
    final picker = ImagePicker();
    XFile? imagepicked = await picker.pickImage(source: ImageSource.gallery);
    if (imagepicked == null) return null;

    setState(() {
      image = File(imagepicked.path);
    });
    return image;
  }

  Future<File?> pickImageFromCamera() async {
    final picker = ImagePicker();
    XFile? imagepicked = await picker.pickImage(source: ImageSource.camera);
    if (imagepicked == null) return null;

    setState(() {
      image = File(imagepicked.path);
    });
    return image;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeader(
              icon: Icons.library_add,
              title: S.of(context).createYourFlashcard,
              subTitle: S.of(context).createFlashcardSubtitle,
            ),
            const SizedBox(height: 30),

            // ===== Select Collection =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: context.read<GetCollectionsCubit>(),
                            child: CollectionView(),
                          ),
                        ),
                      );

                      if (result != null && result is Map<String, dynamic>) {
                        setState(() {
                          selectedCollectionName = result['name'];
                          selectedCollectionId = result['id'];
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        selectedCollectionName ??
                            S.of(context).selectCollection,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const Icon(Icons.arrow_forward_ios, size: 18),
              ],
            ),

            const SizedBox(height: 20),

            CustomTextField(
              controller: frontSideController,
              hint: "Front Side",
              icon: Icons.edit,
              imagePath: frontImage,
              onImageCanel: () {
                setState(() {
                  frontImage = null;
                });
              },
              onImageTap: () {
                showDialog(
                  context: context,
                  builder: (simpleDialogContext) {
                    return CameraOrGalleryDialog(
                      onPressedGallery: () async {
                        frontImage = await pickImageFromGallery();
                        Navigator.pop(context);
                      },
                      onPressedCamera: () async {
                        frontImage = await pickImageFromCamera();
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),

            SizedBox(height: 20),

            CustomTextField(
              controller: backSideController,
              hint: "Back Side",
              icon: Icons.edit,
              imagePath: backImage,
              onImageCanel: () {
                setState(() {
                  backImage = null;
                });
              },
              onImageTap: () {
                showDialog(
                  context: context,
                  builder: (simpleDialogContext) {
                    return CameraOrGalleryDialog(
                      onPressedGallery: () async {
                        backImage = await pickImageFromGallery();
                        Navigator.pop(context);
                      },
                      onPressedCamera: () async {
                        backImage = await pickImageFromCamera();
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 30),

            // ===== Submit button =====
            AppButton(
              text: S.of(context).addCard,
              onPressed: () {
                final frontSide = frontSideController.text.trim();
                final backSide = backSideController.text.trim();

                if (frontSide.isEmpty ||
                    backSide.isEmpty ||
                    selectedCollectionId == null ||
                    frontImage == null ||
                    backImage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        S.of(context).PleaseFillAllFieldsAndSelectACollection,
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                context.read<NormalCardCubit>().addNormalCard(
                  frontSide: frontSide,
                  backSide: backSide,
                  collectionId: selectedCollectionId!,
                  //imagePath: selectedImage!.path, // ← أهو
                );

                frontSideController.clear();
                backSideController.clear();
                setState(() {
                  frontImage = null;
                  backImage = null;
                });
              },
              icon: Icons.add,
            ),
          ],
        ),
      ),
    );
  }
}
