import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/add_collection_cubit/add_collection_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/add_collection_cubit/add_collection_states.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/home_view_body.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/add_options.dart';
import 'package:smart_cards/core/messages/message.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 2,
        centerTitle: true,
        title: const Text(
          'Smart Cardz',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: HomeViewBody(),
      floatingActionButton:
          BlocConsumer<AddCollectionCubit, AddCollectionStates>(
            listener: (context, state) {
              if (state is AddCollectionFailure) {
                Message().MessageErrorMethod(
                  context,
                  message: state.errMessage,
                );
              }
              if (state is AddCollectionSuccess) {
                Message().MessageSuccessMethod(
                  context,
                  message: 'Collection created successfully',
                );
              }

              if (state is AddCollectionLoading) {
                Center(child: CircularProgressIndicator());
              }
            },
            builder: (context, state) {
              return AddOptions(
                collectionId: state is AddCollectionSuccess
                    ? state.collectionModel.collection_id
                    : '',
              );
            },
          ),
    );
  }
}
