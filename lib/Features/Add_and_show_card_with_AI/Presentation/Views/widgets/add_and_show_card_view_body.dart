import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_and_show_card_cubit/add_and_show_card_cubit.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_and_show_card_cubit/add_and_show_card_states.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_success_card.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_text_field.dart';
import 'package:smart_cards/core/utils/widgets/app_show_dialog.dart';
import 'package:smart_cards/core/utils/widgets/custom_loading_indicator.dart';
import 'package:smart_cards/core/utils/widgets/app_header.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/core/views/collection_view.dart';
import 'package:smart_cards/generated/l10n.dart';

class AddAndShowCardViewBody extends StatefulWidget {
  const AddAndShowCardViewBody({super.key});

  @override
  State<AddAndShowCardViewBody> createState() => _AddAndShowCardViewBodyState();
}

class _AddAndShowCardViewBodyState extends State<AddAndShowCardViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  final TextEditingController textController = TextEditingController();
  String? selectedCollectionName;
  String? selectedCollectionId;
  String? word;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    fadeAnimation = CurvedAnimation(parent: controller, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocConsumer<AddAndShowCardCubit, AddAndShowCardStates>(
        listener: (context, state) {
          if (state is AddAndShowCardFailure) {
            AppShowDialog.buildShowSnackBar(context, state.errorMessage);
          }
          if (state is ShowCardSuccess) {
            controller.forward(from: 0);
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AppHeader(
                  icon: Icons.auto_awesome,
                  title: S.of(context).createYourFlashcard,
                  subTitle: S.of(context).createFlashcardSubtitle,
                ),
                SizedBox(height: 20.h),
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

                          if (result != null &&
                              result is Map<String, dynamic>) {
                            setState(() {
                              selectedCollectionName = result['name'];
                              selectedCollectionId = result['id'];
                            });
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                          margin: EdgeInsets.only(right: 8.w),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(5.r),
                          ),
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
                SizedBox(height: 30.h),
                CustomTextField(
                  controller: textController,
                  onSubmitted: (value) {
                    if (value.trim().isEmpty) {
                      AppShowDialog.buildShowSnackBar(
                        context,
                        S.of(context).pleaseEnterAWord,
                      );
                      return;
                    }
                    setState(() => word = value.trim());
                    context.read<AddAndShowCardCubit>().showCard(
                      word: value.trim(),
                    );
                  },
                  icon: Icons.search_rounded,
                  hint: S.of(context).enterWordToGenerate,
                ),
                SizedBox(height: 24.h),

                if (state is AddAndShowCardLoading)
                  Column(
                    children: [
                      SizedBox(height: 30.h),
                      const CustomLoadingIndicator(),
                      SizedBox(height: 12.h),
                      Text(
                        S.of(context).generatingYourSmartCard,
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                if (state is ShowCardSuccess)
                  FadeTransition(
                    opacity: fadeAnimation,
                    child: CustomSuccessCard(
                      card: state.card,
                      textController: textController,
                      selectedCollectionId: selectedCollectionId,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    textController.dispose();
    super.dispose();
  }
}
