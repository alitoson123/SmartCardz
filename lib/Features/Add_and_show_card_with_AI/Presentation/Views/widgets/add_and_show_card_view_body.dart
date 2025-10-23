import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_and_show_card_cubit/add_and_show_card_cubit.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/View_model/add_and_show_card_cubit/add_and_show_card_states.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_success_card.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Presentation/Views/widgets/custom_text_field.dart';
import 'package:smart_cards/core/utils/constants.dart';
import 'package:smart_cards/core/utils/custom_loading_indicator.dart';
import 'package:smart_cards/core/utils/app_header.dart';

class AddAndShowCardViewBody extends StatefulWidget {
  const AddAndShowCardViewBody({super.key});

  @override
  State<AddAndShowCardViewBody> createState() => _AddAndShowCardViewBodyState();
}

class _AddAndShowCardViewBodyState extends State<AddAndShowCardViewBody>
    with SingleTickerProviderStateMixin {
  String? word;
  late AnimationController controller;
  late Animation<double> fadeAnimation;
  final TextEditingController textController = TextEditingController();
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
            AppConstant.buildShowSnackBar(context, state.errorMessage);
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
                  title: 'Create Your Flashcard',
                  subTitle: 'Add a new word and its definition to your deck',
                ),
                SizedBox(height: 30.h),
                CustomTextField(
                  controller: textController,
                  onSubmitted: (value) {
                    if (value.trim().isEmpty) {
                      AppConstant.buildShowSnackBar(
                        context,
                        'Please enter a word',
                      );
                      return;
                    }
                    setState(() => word = value.trim());
                    context.read<AddAndShowCardCubit>().showCard(
                      word: value.trim(),
                    );
                  },
                  icon: Icons.search_rounded,
                  hint: 'Enter a word to generate...',
                ),
                SizedBox(height: 24.h),

                if (state is AddAndShowCardLoading)
                  Column(
                    children: [
                      const SizedBox(height: 30),
                      const CustomLoadingIndicator(),
                      SizedBox(height: 12.h),
                      const Text(
                        "Generating your smart card...",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                if (state is ShowCardSuccess)
                  FadeTransition(
                    opacity: fadeAnimation,
                    child: CustomSuccessCard(card: state.card, textController: textController,),
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
