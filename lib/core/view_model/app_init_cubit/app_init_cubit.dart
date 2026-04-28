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
      // Hive
      await Hive.initFlutter();
      Hive.registerAdapter(UserModelAdapter());
      Hive.registerAdapter(TimestampAdapter());

      await Hive.openBox<UserModel>(K_USER_BOX);

      // SharedPreferences
      await SharedPreferencesService.instance.init();

      // Notifications
      await localnotificationService.init();

      // Notifications First Launch Logic
      final prefs = SharedPreferencesService.instance;
      final isFirstLaunch = prefs.getBool('is_first_launch') ?? true;
      if (isFirstLaunch) {
        // Schedule default reminder at 5:00 PM
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

      setup();

      // Remote Config
      RemoteConfigService.init();

      emit(AppInitSuccessState());
    } catch (e) {
      emit(AppInitFailedState(errMessage: e.toString()));
    }
  }
}
