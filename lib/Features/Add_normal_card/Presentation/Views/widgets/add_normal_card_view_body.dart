import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_text_field.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/View_model/normal_card_cubit/normal_card_cubit.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/widgets/card_selection_row.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/widgets/image_picker_helper.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/widgets/type_of_collections.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collections_stats_cubit/collections_stats_cubit.dart';
import 'package:smart_cards/core/messages/message.dart';
import 'package:smart_cards/core/services/image_service/put_image_and_get_url.dart';
import 'package:smart_cards/core/utils/helpers/network_utils.dart';
import 'package:smart_cards/core/utils/widgets/app_button.dart';
import 'package:smart_cards/core/utils/widgets/app_header.dart';
import 'package:smart_cards/core/views/collection_view.dart';
import 'package:smart_cards/core/views/widgets/app_dialog.dart';
import 'package:smart_cards/generated/l10n.dart';
import 'package:smart_cards/core/views/widgets/banner_ad_widget.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  //   Header
                  AppHeader(
                    icon: Icons.library_add,
                    title: S.of(context).createYourFlashcard,
                    subTitle: S.of(context).createFlashcardSubtitle,
                  ),
                  SizedBox(height: 25.h),

                  //  the collection and type selection row
                  CardSelectionRow(
                    selectedCollectionName: selectedCollectionName,
                    selectedType: selectedType,
                    onTapCollection: _onCollectionTapped,
                    onTapType: _onTypeTapped,
                  ),

                  SizedBox(height: 24.h),
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
                      showImagePickerDialog(context, (picked) {
                        if (!mounted) return;
                        setState(() {
                          frontImage = picked;
                        });
                      });
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
                        showImagePickerDialog(context, (picked) {
                          if (!mounted) return;
                          setState(() {
                            backImage = picked;
                          });
                        });
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
          ),
        ),
        // for google ads
        SizedBox(height: 8.h),
        const BannerAdWidget(), // ← Adds banner at the bottom
      ],
    );
  }

  Future<void> _onCollectionTapped() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider.value(
          value: context.read<GetCollectionsCubit>(),
          child: const CollectionView(),
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
  }

  Future<void> _onTypeTapped() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TypeOfCollections()),
    );

    if (!mounted) return;
    if (result != null) {
      setState(() {
        selectedType = result['name'];
        selectedTypeId = result['id'];
      });
    }
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
    }

    if (selectedCollectionId == null) {
      Message().showAppDialog(
        context: context,
        type: DialogType.warning,
        message: S.of(context).PleaseSelectACollection,
      );
      return;
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
      builder: (context) => const Center(child: CircularProgressIndicator()),
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
            Message().showAppDialog(
              context: context,
              type: DialogType.error,
              message: S.of(context).FailedToUploadTheImage,
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
            Message().showAppDialog(
              context: context,
              type: DialogType.error,
              message: S.of(context).FailedToUploadTheImage,
            );
          }
          return;
        }
      }

      // Close loading dialog
      if (mounted) Navigator.pop(context);

      // Add card to Firestore and wait for completion before refreshing stats
      if (mounted) {
        await context.read<NormalCardCubit>().addNormalCard(
          frontSide: frontSide,
          backSide: backSide,
          frontImageUrl: frontImageUrl ?? '',
          backImageUrl: backImageUrl ?? '',
          frontImagePath: frontImageRef?.fullPath ?? '',
          backImagePath: backImageRef?.fullPath ?? '',
          collectionId: selectedCollectionId!,
          cardId: cardId,
        );
        if (!mounted) return;
        context.read<CollectionsStatsCubit>().forceRefreshCollection(
          selectedCollectionId!,
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
          const SnackBar(
            content: Text('Card added successfully!'),
            duration: Duration(milliseconds: 800),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);

      if (!mounted) return;
      Message().showAppDialog(
        context: context,
        type: DialogType.error,
        message: 'Error adding card: $e',
      );
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
// The rule is: after every await, treat it like a fresh start — check mounted before touching context.
