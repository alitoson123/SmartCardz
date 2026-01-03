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
                _buildSelectionTile(
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
