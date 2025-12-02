import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/add_collection_cubit/add_collection_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/add_collection_cubit/add_collection_states.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/home_view_body.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/add_options.dart';
import 'package:smart_cards/core/messages/message.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:smart_cards/generated/l10n.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).home),
        actions: [
          IconButton(
            onPressed: () {
              context.push(AppRoutes.settingsScreen);
            },
            icon: Icon(Icons.settings, color: Colors.white),
          ),
        ],
      ),
      body: HomeViewBody(),
      floatingActionButton:
          BlocListener<AddCollectionCubit, AddCollectionStates>(
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
                  message: S.of(context).CollectionCreatedSuccessfully,
                );
              }

              if (state is AddCollectionLoading) {
                Center(child: CircularProgressIndicator());
              }
            },
            child: AddOptions(),
          ),
    );
  }
}
