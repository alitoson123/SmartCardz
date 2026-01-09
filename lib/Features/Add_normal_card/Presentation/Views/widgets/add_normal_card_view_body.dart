import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_text_field.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/View_model/normal_card_cubit/normal_card_cubit.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/widgets/camera_or_gallery_dialog.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/widgets/type_of_collections.dart';
import 'package:smart_cards/core/utils/widgets/app_button.dart';
import 'package:smart_cards/core/utils/widgets/app_header.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/core/views/collection_view.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';

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
  String selectedType = "Basic";

  File? frontImage;
  File? backImage;
  Reference? frontImageRef;
  Reference? backImageRef;

  // Pick image from gallery and return File
  Future<File?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage == null) return null;

    return File(pickedImage.path);
  }

  // Pick image from camera and return File
  Future<File?> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.camera);

    if (pickedImage == null) return null;

    return File(pickedImage.path);
  }

  Future<File> compressImage(File file) async {
    final dir = await getTemporaryDirectory();
    final targetPath =
        '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.webp';

    final result = await FlutterImageCompress.compressAndGetFile(
      file.path,
      targetPath,
      quality: 75, // جودة ممتازة وحجم قليل
      minWidth: 1080, // تصغير العرض لـ1080
      format: CompressFormat.webp, // WebP يقلل الحجم جداً
    );

    return File(result!.path);
  }

  // Generate storage reference for image
  Reference? generateImageReference({
    required String side,
    required String cardId,
  }) {
    User? user = FirebaseAuth.instance.currentUser;
    final String userId = user!.uid;

    final storageRef = FirebaseStorage.instance.ref();

    final imageRef = storageRef.child('cards/$userId/$cardId/$side.webp');

    return imageRef;
  }

  Future<String> putAndGetUrl(Reference? imageRef, File imageFile) async {
    try {
      final compressedImage = await compressImage(imageFile);

      await imageRef!.putFile(compressedImage);

      final imageUrl = await imageRef.getDownloadURL();

      log('✅ Upload successful!');

      return imageUrl;
    } catch (e) {
      log('❌ Upload error: $e');
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppHeader(
              icon: Icons.library_add,
              title: S.of(context).createYourFlashcard,
              subTitle: S.of(context).createFlashcardSubtitle,
            ),
            SizedBox(height: 25.h),

            // ===== Selection Tiles (Horizontal) =====
            Row(
              children: [
                Expanded(
                  child: _buildSelectionTile(
                    label:
                        selectedCollectionName ??
                        //  S.of(context).selectCollection,
                        'Collection',
                    icon: Icons.collections_bookmark_rounded,
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
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _buildSelectionTile(
                    label: selectedType,
                    icon: Icons.style_rounded,
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TypeOfCollections(),
                        ),
                      );

                      if (result != null) {
                        setState(() {
                          selectedType = result['name'];
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // ===== Front Side Field =====
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
                        final picked = await pickImageFromGallery();
                        if (picked != null) {
                          setState(() {
                            frontImage = picked;
                          });
                        }
                        Navigator.pop(context);
                      },
                      onPressedCamera: () async {
                        final picked = await pickImageFromCamera();
                        if (picked != null) {
                          setState(() {
                            frontImage = picked;
                          });
                        }
                        Navigator.pop(context);
                      },
                    );
                  },
                );
              },
            ),

            SizedBox(height: 16.h),

            // ===== Back Side Field (only for Basic type) =====
            Visibility(
              visible: selectedType == "Basic",
              child: CustomTextField(
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
                          final picked = await pickImageFromGallery();
                          if (picked != null) {
                            setState(() {
                              backImage = picked;
                            });
                          }
                          Navigator.pop(context);
                        },
                        onPressedCamera: () async {
                          final picked = await pickImageFromCamera();
                          if (picked != null) {
                            setState(() {
                              backImage = picked;
                            });
                          }
                          Navigator.pop(context);
                        },
                      );
                    },
                  );
                },
              ),
            ),

            SizedBox(height: 50.h),

            // ===== Submit button =====
            AppButton(
              text: S.of(context).addCard,
              onPressed: () async {
                final frontSide = frontSideController.text.trim();
                final backSide = backSideController.text.trim();

                // Validation
                if (selectedType == "Basic") {
                  if ((frontSide.isEmpty && frontImage == null) ||
                      (backSide.isEmpty && backImage == null) ||
                      selectedCollectionId == null) {
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
                } else if (selectedType == "Front") {
                  if ((frontSide.isEmpty && frontImage == null) ||
                      selectedCollectionId == null) {
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
                }

                // Show loading indicator
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      Center(child: CircularProgressIndicator()),
                );

                try {
                  // Pre-generate the Firestore document ID for this card
                  final cardId = FirebaseFirestore.instance
                      .collection('cards')
                      .doc()
                      .id;

                  // Upload images and get URLs
                  String? frontImageUrl;
                  String? backImageUrl;

                  if (frontImage != null) {
                    frontImageRef = generateImageReference(
                      side: 'front',
                      cardId: cardId,
                    );
                    frontImageUrl = await putAndGetUrl(
                      frontImageRef,
                      frontImage!,
                    );
                    if (frontImageUrl.isEmpty) {
                      // Upload failed
                      Navigator.pop(context); // Close loading dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to upload front image'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                  }

                  if (backImage != null && selectedType == "Basic") {
                    backImageRef = generateImageReference(
                      side: 'back',
                      cardId: cardId,
                    );
                    backImageUrl = await putAndGetUrl(backImageRef, backImage!);
                    if (backImageUrl.isEmpty) {
                      // Upload failed
                      Navigator.pop(context); // Close loading dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Failed to upload back image'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                  }

                  // Close loading dialog
                  Navigator.pop(context);

                  // Add card to Firestore
                  context.read<NormalCardCubit>().addNormalCard(
                    frontSide: frontSide,
                    backSide: backSide,
                    frontImageUrl: frontImageUrl ?? '',
                    backImageUrl: backImageUrl ?? '',
                    frontImagePath: frontImageRef?.fullPath ?? '',
                    backImagePath: backImageRef?.fullPath ?? '',
                    collectionId: selectedCollectionId!,
                    cardId: cardId,
                  );

                  // Clear form
                  frontSideController.clear();
                  backSideController.clear();
                  setState(() {
                    frontImage = null;
                    backImage = null;
                    frontImageRef = null;
                    backImageRef = null;
                  });

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Card added successfully!'),
                      duration: Duration(milliseconds: 800),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  // Close loading dialog if still open
                  Navigator.pop(context);

                  log('❌ Error adding card: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error adding card: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              icon: Icons.add,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionTile({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: theme.brightness == Brightness.light
                ? Colors.grey.shade200
                : Colors.white10,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: theme.colorScheme.primary, size: 16.sp),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: theme.hintColor,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }
}
