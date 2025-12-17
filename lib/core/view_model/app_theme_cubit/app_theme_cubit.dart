import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_cards/constant.dart';
import 'package:smart_cards/core/services/Shared_preferences_service/shared_preferences.dart';
import 'package:smart_cards/core/view_model/app_theme_cubit/app_theme_states.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(ThemeInitialState());

  Future<void> changeTheme(String theme) async {
    if (theme == "Light" || theme == "فاتح") {
      await SharedPreferencesService.instance.setString(K_APP_THEME, 'Light');
      emit(ThemeLightState());
    } else if (theme == "Dark" || theme == "داكن") {
      await SharedPreferencesService.instance.setString(K_APP_THEME, 'Dark');
      emit(ThemeDarkState());
    }
  }

  Future<String> getTheme() async {
    var currentTheme = SharedPreferencesService.instance.getString(
      K_APP_THEME,
    );
    return currentTheme ?? 'Light';
  }

  Future<void> loadInitialTheme() async {
    String saved = await getTheme();
    if (saved == "Light") {
      emit(const ThemeLightState());
    } else {
      emit(const ThemeDarkState());
    }
  }
}
