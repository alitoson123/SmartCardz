import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Add_normal_card/Data/Repos_impl/normal_card_repo_impl.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/View_model/normal_card_cubit/normal_card_cubit.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/View_model/normal_card_cubit/normal_card_states.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/widgets/add_normal_card_view_body.dart';
import 'package:smart_cards/core/services/locator_service/service_locator.dart';
import 'package:smart_cards/generated/l10n.dart';

class AddNormalCardView extends StatelessWidget {
  const AddNormalCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).addCard)),
      body: BlocProvider(
        create: (context) =>
            NormalCardCubit(normalCardRepoImpl: getIt<NormalCardRepoImpl>()),
        child: BlocListener<NormalCardCubit, NormalCardStates>(
          listener: (context, state) {
            if (state is AddNormalCardFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
            }
          },
          child: AddNormalCardViewBody(),
        ),
      ),
    );
  }
}
