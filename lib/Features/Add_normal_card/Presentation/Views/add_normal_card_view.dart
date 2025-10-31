import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Add_normal_card/Data/Repos_impl/normal_card_repo_impl.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/View_model/normal_card_cubit/normal_card_cubit.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/View_model/normal_card_cubit/normal_card_states.dart';
import 'package:smart_cards/Features/Add_normal_card/Presentation/Views/widgets/add_normal_card_view_body.dart';
import 'package:smart_cards/core/services/locator_service/service_locator.dart';
import 'package:smart_cards/core/view_model/get_collections_cubit/get_collections_cubit.dart';

class AddNormalCardView extends StatelessWidget {
  const AddNormalCardView({super.key, required this.collectionId});
  final String collectionId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Add New Card',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
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
            if (state is AddNormalCardSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Card saved successfully'),
                  duration: const Duration(milliseconds: 500),
                ),
              );
            }
            if (state is AddNormalCardLoading) {
              Center(child: CircularProgressIndicator());
            }
          },
          child: AddNormalCardViewBody(collectionId: collectionId),
        ),
      ),
    );
  }
}
