import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/services/Shared_preferences_service/shared_preferences.dart';
import 'package:smart_cards/core/view_model/app_language_cubit/app_language_states.dart';

class AppLanguageCubit extends Cubit<AppLanguageState> {
  AppLanguageCubit() : super(AppLanguageInitialState());

  Future<void> changeLanguage(String language) async {
    if (language == 'en') {
      await SharedPreferencesService.instance.setString(AppConstants.K_APP_LANGUAGE, 'en');
      emit(AppLanguageEnState());
    } else if (language == 'ar') {
      await SharedPreferencesService.instance.setString(AppConstants.K_APP_LANGUAGE, 'ar');
      emit(AppLanguageArState());
    }
  }

  Future<void> loadInitialLanguage() async {
    String saved =
        SharedPreferencesService.instance.getString(AppConstants.K_APP_LANGUAGE) ?? 'en';
    if (saved == "ar") {
      emit(const AppLanguageArState());
    } else {
      emit(const AppLanguageEnState());
    }
  }
}
