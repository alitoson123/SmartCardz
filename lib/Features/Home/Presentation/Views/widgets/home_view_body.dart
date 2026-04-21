import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_states.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/create_collection.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/list_of_collections.dart';
import 'package:flutter/material.dart';

class HomeViewBody extends StatefulWidget {
  const HomeViewBody({super.key});

  @override
  State<HomeViewBody> createState() => _HomeViewBodyState();
}

class _HomeViewBodyState extends State<HomeViewBody> {
  @override
  void initState() {
    context.read<GetCollectionsCubit>().getCollections();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetCollectionsCubit, GetCollectionsStates>(
      builder: (context, state) {
        if (state is GetCollectionsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GetCollectionsFailure) {
          return Center(child: Text(state.errMessage));
        } else if (state is GetCollectionsSuccess) {
          final collections = state.collections;
          if (collections.isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // to prevent error of calling showDialog in build method
              showDialog(
                // because it needs a widget and showDialog is a function
                context: context,
                builder: (context) => const CreateCollectionDialog(),
              );
            });
            return const SizedBox.shrink();
          }

          return ListOfCollections(collections: collections);
        }
        return const SizedBox.shrink();
      },
    );
  }
}
