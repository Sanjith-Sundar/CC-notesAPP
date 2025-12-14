import 'package:flutter/material.dart';

class AppColors {
  static const Color background = Color(0xFF1E1E2E);
  static const Color surface = Color(0xFF313244);
  static const Color text = Color(0xFFCDD6F4);
  static const Color accent = Color(0xFF89B4FA);
}

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.background,
  primaryColor: AppColors.accent,
  colorScheme: ColorScheme.dark(
    primary: AppColors.accent,
    secondary: AppColors.accent,
    surface: AppColors.surface,
    onPrimary: AppColors.text,
    onSecondary: AppColors.text,
    onSurface: AppColors.text,
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.text),
    bodyMedium: TextStyle(color: AppColors.text),
    titleLarge: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.accent,
  ),
  cardTheme: CardTheme(
    color: AppColors.surface,
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.background,
    elevation: 0,
    titleTextStyle: TextStyle(
      color: AppColors.text,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(color: AppColors.accent),
  ),
);
