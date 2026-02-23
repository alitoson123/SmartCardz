import 'dart:developer';
import 'dart:io';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/widgets/custom_selection.dart';
import 'package:smart_cards/core/services/image_service/picking_an_image.dart';
import 'package:smart_cards/core/services/image_service/put_image_and_get_url.dart';
import 'package:smart_cards/core/utils/helpers/network_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  late String selectedType;
  String selectedTypeId = '1'; // Default to 'Basic'

  File? frontImage;
  File? backImage;
  Reference? frontImageRef;
  Reference? backImageRef;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize selectedType based on selectedTypeId
    if (selectedTypeId == '1') {
      selectedType = S.of(context).basic;
    } else {
      selectedType = S.of(context).frontOnly;
    }
  }

  // Pick image from gallery and return File

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //***************************************************** */
            //   Header
            AppHeader(
              icon: Icons.library_add,
              title: S.of(context).createYourFlashcard,
              subTitle: S.of(context).createFlashcardSubtitle,
            ),
            SizedBox(height: 25.h),

            //***************************************************** */
            //   Selection section
            buildSelectionRow(), // Extracted method

            SizedBox(height: 24.h),
            //***************************************************** */
            //  the Text fields

            //   Front Side Field
            CustomTextField(
              controller: frontSideController,
              hint: selectedTypeId == '1'
                  ? S.of(context).EnterYourQuestion
                  : S.of(context).EnterYourInformation,
              imagePath: frontImage,
              onImageCanel: () {
                setState(() {
                  frontImage = null;
                });
              },
              onImageTap: () {
                showDialog(
                  // pick image from gallery or camera
                  context: context,
                  builder: (simpleDialogContext) {
                    return CameraOrGalleryDialog(
                      onPressedGallery: () async {
                        // pick image from gallery
                        final picked = await PickingAnImage()
                            .pickImageFromGallery();
                        if (!mounted) return;
                        if (picked != null) {
                          setState(() {
                            frontImage = picked;
                          });
                        }
                        Navigator.pop(context);
                      },
                      onPressedCamera: () async {
                        // pick image from camera
                        final picked = await PickingAnImage()
                            .pickImageFromCamera();
                        if (!mounted) return;
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

            // Back Side Field (only for Basic type)
            Visibility(
              visible: selectedTypeId == '1', // only for Basic type
              child: CustomTextField(
                controller: backSideController,
                hint: S.of(context).EnterYourAnswer,
                imagePath: backImage,
                onImageCanel: () {
                  setState(() {
                    backImage = null;
                  });
                },
                onImageTap: () {
                  showDialog(
                    // pick image from gallery or camera
                    context: context,
                    builder: (simpleDialogContext) {
                      return CameraOrGalleryDialog(
                        onPressedGallery: () async {
                          // pick image from gallery
                          final picked = await PickingAnImage()
                              .pickImageFromGallery();
                          if (!mounted) return;
                          if (picked != null) {
                            setState(() {
                              backImage = picked;
                            });
                          }
                          Navigator.pop(context);
                        },
                        onPressedCamera: () async {
                          // pick image from camera
                          final picked = await PickingAnImage()
                              .pickImageFromCamera();
                          if (!mounted) return;
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

            //***************************************************** */
            //  add button
            AppButton(
              text: S.of(context).addCard,
              onPressed: addCard,
              icon: Icons.add,
            ),
          ],
        ),
      ),
    );
  }

  //   Selection section
  Widget buildSelectionRow() {
    return Row(
      children: [
        Expanded(
          child: CustomSelection(
            // select a collection
            label: selectedCollectionName ?? S.of(context).selectCollection,

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

              if (!mounted) return;
              if (result != null) {
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
          child: CustomSelection(
            // select a type of the collection
            label: selectedType,
            icon: Icons.style_rounded,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TypeOfCollections()),
              );

              if (!mounted) return;
              if (result != null) {
                setState(() {
                  selectedType = result['name'];
                  selectedTypeId = result['id'];
                });
              }
            },
          ),
        ),
      ],
    );
  }

  Future<void> addCard() async {
    final frontSide = frontSideController.text.trim();
    final backSide = backSideController.text.trim();

    // Validation for missing fields
    if (selectedTypeId == '1') {
      // Validation for missing fields in Basic type
      if ((frontSide.isEmpty && frontImage == null) ||
          (backSide.isEmpty && backImage == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).PleaseFillAllFields),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (selectedCollectionId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).PleaseSelectACollection),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    } else if (selectedTypeId == '2') {
      // Validation for missing fields in front only type
      if (frontSide.isEmpty && frontImage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).PleaseFillAllFields),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (selectedCollectionId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(S.of(context).PleaseSelectACollection),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
    }

    //****************************************************************************/

    // Check the network connection
    if (!await NetworkUtils.isOnline()) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).NoInternetConnection),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading indicator
    if (!mounted) return;
    showDialog(
      ////////////////////////////////////////////////////////////////////////
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );

    try {
      // Pre-generate the Firestore document ID for this card
      final cardId = FirebaseFirestore.instance.collection('cards').doc().id;

      // Upload images and get URLs
      String? frontImageUrl;
      String? backImageUrl;

      if (frontImage != null) {
        // upload front image

        frontImageRef = PutImageAndGetUrl.generateImageReference(
          // generate image reference
          side: 'front',
          cardId: cardId,
        );
        frontImageUrl = await PutImageAndGetUrl.putAndGetUrl(
          // upload image and get url
          frontImageRef,
          frontImage!,
        );
        if (frontImageUrl.isEmpty) {
          // check if upload failed and get an empty string
          // Upload failed
          if (mounted) {
            Navigator.pop(context); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to upload front image'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      if (backImage != null && selectedTypeId == '1') {
        // upload back image (only for Basic type)
        backImageRef = PutImageAndGetUrl.generateImageReference(
          // generate image reference
          side: 'back',
          cardId: cardId,
        );
        backImageUrl = await PutImageAndGetUrl.putAndGetUrl(
          backImageRef,
          backImage!,
        ); // upload image and get url
        if (backImageUrl.isEmpty) {
          // check if upload failed and get an empty string
          // Upload failed
          if (mounted) {
            Navigator.pop(context); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Failed to upload back image'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Add card to Firestore
      if (mounted) {
        /*final repo = RevisionRepo();
  
  
    final cardId = await repo.addCard(
      deckId: selectedCollectionId!,
      question: frontSide,
      answer: backSide,
      questionImageUrl: frontImageUrl,
      answerImageUrl: backImageUrl,
      questionImagePath: frontImageRef?.fullPath,
      answerImagePath: backImageRef?.fullPath,
    );
    
    print('✅ تم إضافة الكارت: $cardId');
    */
        // رجوع أو أي action
        //    Navigator.pop(context);

        ///
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
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) Navigator.pop(context);

      log('❌ Error adding card: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding card: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

/***
 * 
 أهم الأماكن اللي لازم تستخدم فيها mounted

بعد أي:

await

Navigator.push

showDialog

Firebase call

HTTP request

Image picker
 */
