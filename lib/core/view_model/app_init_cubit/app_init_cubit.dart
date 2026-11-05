import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_cards/Features/Auth/Data/models/user_model.dart';
import 'package:smart_cards/core/services/notifications_service/local_notification_service.dart';
import 'package:smart_cards/core/services/remote_config/remote_config.dart';
import 'package:smart_cards/core/utils/hive_adapters/timestamp_adapter.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/services/Shared_preferences_service/shared_preferences.dart';
import 'package:smart_cards/core/services/locator_service/service_locator.dart';
import 'package:smart_cards/core/view_model/app_init_cubit/app_init_states.dart';

class AppInitCubit extends Cubit<AppInitState> {
  AppInitCubit() : super(AppInitInitialState());

  Future<void> initialize() async {
    emit(AppInitLoadingState());

    try {
      // 1. Ensure dependency injection is ready
      setup();

      // 2. Critical local storage initialization
      await Future.wait([
        SharedPreferencesService.instance.init(),
        () async {
          await Hive.initFlutter();
          if (!Hive.isAdapterRegistered(UserModelAdapter().typeId)) {
            Hive.registerAdapter(UserModelAdapter());
          }
          if (!Hive.isAdapterRegistered(TimestampAdapter().typeId)) {
            Hive.registerAdapter(TimestampAdapter());
          }
          if (!Hive.isBoxOpen(AppConstants.K_USER_BOX)) {
            await Hive.openBox<UserModel>(AppConstants.K_USER_BOX);
          }
        }(),
      ]);

      // 3. Fire-and-forget non-critical background services
      _initNonCriticalServices();

      emit(AppInitSuccessState());
    } catch (e) {
      debugPrint('AppInit critical failure: $e');
      emit(AppInitFailedState(errMessage: e.toString()));
    }
  }

  void _initNonCriticalServices() {
    Future.microtask(() async {
      try {
        await localnotificationService.init();

        final prefs = SharedPreferencesService.instance;
        final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;
        if (isFirstLaunch) {
          await localnotificationService.showSchduledNotification(
            id: 4,
            title: 'Smart Cards Revision',
            body: 'Time to review your flashcards and keep your streak going!',
            hour: 17,
            minute: 0,
            isrepeat: true,
          );
          await prefs.setInt('reminder_hour', 5);
          await prefs.setString('reminder_period', 'PM');
          await prefs.setBool('reminder_repeat_daily', true);
          await prefs.setBool('is_reminder_active', true);
          await prefs.setBool('is_first_launch', false);
        }
      } catch (e) {
        debugPrint('Non-critical notification setup error: $e');
      }

      try {
        await RemoteConfigService.init();
      } catch (e) {
        debugPrint('Non-critical remote config setup error: $e');
      }
    });
  }
}
