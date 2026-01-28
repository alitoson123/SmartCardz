import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:smart_cards/Features/Auth/Data/models/user_model.dart';
import 'package:smart_cards/Features/Home/Data/Models/collection_model.dart';
import 'package:smart_cards/Features/Add_and_show_card_with_AI/Data/models/card__with_AI_model.dart';
import 'package:smart_cards/Features/Add_normal_card/Data/models/normal_card_model.dart';
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
      Hive.registerAdapter(CollectionModelAdapter());
      Hive.registerAdapter(CardWithAIModelAdapter());
      Hive.registerAdapter(NormalCardModelAdapter());
      Hive.registerAdapter(TimestampAdapter());

      await Hive.openBox<UserModel>(K_USER_BOX);

      // SharedPreferences
      await SharedPreferencesService.instance.init();

      // Notifications
      // await PushNotificationService.init();

      // Locator
      setup();

      emit(AppInitSuccessState());
    } catch (e) {
      emit(AppInitFailedState(errMessage: e.toString()));
    }
  }
}
