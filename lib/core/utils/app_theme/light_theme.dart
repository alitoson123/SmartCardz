import 'package:flutter/material.dart';

final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.white,
  primaryColor: const Color(0xFF4A90E2),

  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF4A90E2),
    elevation: 2,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: Colors.white),
  ),

  cardColor: Colors.white,
  listTileTheme: ListTileThemeData(
    tileColor: Colors.grey.shade200,
    textColor: Colors.black,
    iconColor: Colors.black,
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide.none,
    ),
    hintStyle: TextStyle(color: Colors.grey.shade500),
  ),

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: Colors.black),
    bodyMedium: TextStyle(color: Colors.black),
    titleLarge: TextStyle(color: Colors.black),
  ),

  colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF4A90E2),
    brightness: Brightness.light,
  ),
);
