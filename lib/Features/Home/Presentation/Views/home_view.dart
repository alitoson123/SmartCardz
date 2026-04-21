import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/add_collection_cubit1.dart/add_collection_cubit.dart';
import 'package:smart_cards/Features/Home/Presentation/View_model/collection_cubit/add_collection_cubit1.dart/add_collection_states.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/home_view_body.dart';
import 'package:smart_cards/Features/Home/Presentation/Views/widgets/add_options.dart';
import 'package:smart_cards/core/messages/message.dart';
import 'package:smart_cards/core/navigator/routes.dart';
import 'package:smart_cards/core/services/Shared_preferences_service/shared_preferences.dart';
import 'package:smart_cards/core/views/widgets/app_dialog.dart';
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
              context.push(AppRoutes.settingsScreen);
            },
            icon: Icon(Icons.settings),
          ),
        ],
      ),
      body: HomeViewBody(),
      floatingActionButton:
          BlocListener<AddCollectionCubit, AddCollectionStates>(
            listener: (context, state) {
              if (state is AddCollectionFailure) {
                Navigator.pop(context);
                Message().showAppDialog(
                  context: context,
                  type: DialogType.error,
                  message: state.errMessage,
                );
              }
              if (state is AddCollectionSuccess) {
                Message().MessageSuccessMethod(
                  context,
                  message: S.of(context).CollectionCreatedSuccessfully,
                );
              }
            },
            child: AddOptions(),
          ),
    );
  }
}
