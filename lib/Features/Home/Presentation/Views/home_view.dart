import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'dart:io' show Platform;
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/actions_collection_cubit/actions_collection_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/actions_collection_cubit/actions_collection_states.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/get_collections_cubit/get_collections_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/home_view_body.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/add_options.dart';
import 'package:smart_cards/core/messages/message.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:smart_cards/core/services/Shared_preferences_service/shared_preferences.dart';
import 'package:smart_cards/core/views/widgets/app_dialog.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/reminder_bottom_sheet.dart';
import 'package:smart_cards/generated/l10n.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    try {
      if (Platform.isAndroid) {
        final updateInfo = await InAppUpdate.checkForUpdate();

        if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
          final prefs = SharedPreferencesService.instance;
          final dismissCount = prefs.getInt('update_dismiss_count') ?? 0;

          // لو رفض أكتر من 3 مرات → حوّله لـ Immediate (إجباري)
          if (dismissCount >= 3) {
            await InAppUpdate.performImmediateUpdate();
          } else {
            final result = await InAppUpdate.startFlexibleUpdate();

            if (result == AppUpdateResult.success) {
              await InAppUpdate.completeFlexibleUpdate();
            } else {
              // رفض → زوّد العداد
              await prefs.setInt('update_dismiss_count', dismissCount + 1);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Update check failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).home),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                useSafeArea: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const ReminderBottomSheet(),
              );
            },
            icon: Icon(Icons.alarm),
          ),
          IconButton(
            onPressed: () {
              context.push(AppRoutes.settingsScreen);
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: HomeViewBody(),
      floatingActionButton:
          BlocConsumer<ActionsCollectionCubit, ActionsCollectionStates>(
            listener: (context, state) {
              if (state is ActionsCollectionFailure) {
                Message().showAppDialog(
                  context: context,
                  type: DialogType.error,
                  message: state.errMessage,
                );
              }

              if (state is AddCollectionSuccess) {
                context.read<GetCollectionsCubit>().addCollectionLocally(
                  state.collectionEntity,
                );
                Message().MessageSuccessMethod(
                  context,
                  message: S.of(context).CollectionCreatedSuccessfully,
                  duration: Duration(milliseconds: 400),
                );
              }

              if (state is DeleteCollectionSuccess) {
                context.read<GetCollectionsCubit>().removeCollectionLocally(
                  state.collectionId,
                );

                Message().MessageSuccessMethod(
                  context,
                  message: S.of(context).collectionDeletedSuccessfully,
                  duration: Duration(milliseconds: 400),
                );
              }

              if (state is RenameCollectionSuccess) {
                context.read<GetCollectionsCubit>().renameCollectionLocally(
                  state.collectionId,
                  state.collectionName,
                );
                Message().MessageSuccessMethod(
                  context,
                  message: S.of(context).collectionRenamedSuccessfully,
                  duration: Duration(milliseconds: 400),
                );
              }
            },
            builder: (context, state) {
              return ModalProgressHUD(
                inAsyncCall: state is ActionsCollectionLoading,
                opacity: 0.5,
                progressIndicator: CircularProgressIndicator(),
                child: AddOptions(),
              );
            },
          ),
    );
  }
}
