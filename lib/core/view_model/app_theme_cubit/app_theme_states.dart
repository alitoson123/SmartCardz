import 'package:flutter/material.dart';

abstract class ThemeState {
  final ThemeMode themeMode;
  const ThemeState(this.themeMode);
}

class ThemeInitialState extends ThemeState {
  const ThemeInitialState() : super(ThemeMode.system);
}

class ThemeLightState extends ThemeState {
  const ThemeLightState() : super(ThemeMode.light);
}

class ThemeDarkState extends ThemeState {
  const ThemeDarkState() : super(ThemeMode.dark);
}
