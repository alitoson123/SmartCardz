import 'dart:developer';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path/path.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_text_field.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/View_model/normal_card_cubit/normal_card_cubit.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/widgets/camera_or_gallery_dialog.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/widgets/type_of_collections.dart';
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
  String selectedType = "Basic";

  File? frontImage;
  File? backImage;
  
  // Store XFile references for upload
  XFile? frontImageXFile;
  XFile? backImageXFile;

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

  // Upload image and get download URL
  Future<String> uploadAndGetImageUrl(File imageFile) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      
    

      final storageRef = FirebaseStorage.instance.ref();
      final String userId = user!.uid;
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      
      // Create unique filename to avoid overwriting
      
      // Path matches Storage rules: /cards/{userId}/...
      final imageRef = storageRef.child("cards/$userId/image_$timestamp");

      
      // Upload the file
      await imageRef.putFile(imageFile);
      
      // Get download URL
      final imageUrl = await imageRef.getDownloadURL();
      
      log('✅ Upload successful!');
      log('✅ Download URL: $imageUrl');
      
      return imageUrl;
    } on FirebaseException catch (e) {
      log('❌ Firebase error: ${e.code} - ${e.message}');
      return "";
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
            SizedBox(height: 30.h),

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
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      margin: EdgeInsets.only(right: 8.w),
                      child: Text(
                        selectedCollectionName ??
                            S.of(context).selectCollection,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 18.sp),
              ],
            ),
            SizedBox(height: 15.h),

            // ===== Select the type =====
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
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
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      margin: EdgeInsets.only(right: 8.w),
                      child: Text(
                        selectedType,
                        style: TextStyle(fontSize: 16.sp),
                      ),
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 18.sp),
              ],
            ),
            SizedBox(height: 20.h),

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

            SizedBox(height: 20.h),

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

            SizedBox(height: 30.h),

            // ===== Submit button =====
            AppButton(
              text: S.of(context).addCard,
              onPressed: () async {
                final frontSide = frontSideController.text.trim();
                final backSide = backSideController.text.trim();

                // Validation
                if (selectedType == "Basic") {
                  if (frontSide.isEmpty ||
                      backSide.isEmpty ||
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
                  if (frontSide.isEmpty || selectedCollectionId == null) {
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
                  builder: (context) => Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                try {
                  // Upload images and get URLs
                  String? frontImageUrl;
                  String? backImageUrl;

                  if (frontImage != null) {
                    frontImageUrl = await uploadAndGetImageUrl(frontImage!);
                    if (frontImageUrl.isEmpty) {
                      // Upload failed
                      Navigator.pop(context); // Close loading dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to upload front image'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                  }

                  if (backImage != null && selectedType == "Basic") {
                    backImageUrl = await uploadAndGetImageUrl(backImage!);
                    if (backImageUrl.isEmpty) {
                      // Upload failed
                      Navigator.pop(context); // Close loading dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
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
                    collectionId: selectedCollectionId!,
                    imagePath: frontImageUrl ?? "", // Pass front image URL
                    // If you have a backImagePath parameter, pass backImageUrl here
                  );

                  // Clear form
                  frontSideController.clear();
                  backSideController.clear();
                  setState(() {
                    frontImage = null;
                    backImage = null;
                  });

                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Card added successfully!'),
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
}