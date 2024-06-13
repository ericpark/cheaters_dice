import 'package:flutter/material.dart';

const ColorScheme _colorScheme = ColorScheme(
  primary: Color(0xFF6200EE),
  primaryContainer: Color(0xFF3700B3),
  secondary: Color(0xFF03DAC6),
  secondaryContainer: Color(0xFF018786),
  surface: Color(0xFFFFFFFF),
  error: Color(0xFFB00020),
  onPrimary: Color(0xFFFFFFFF),
  onSecondary: Color(0xFF000000),
  onSurface: Color(0xFF000000),
  onError: Color(0xFFFFFFFF),
  brightness: Brightness.light,
);

final ThemeData themeData = ThemeData(
  colorScheme: _colorScheme,
  useMaterial3: true,
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: _colorScheme.onSurface,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: _colorScheme.onSurface,
    ),
    displaySmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: _colorScheme.onSurface,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: _colorScheme.onSurface,
    ),
    headlineSmall: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: _colorScheme.onSurface,
    ),
    titleLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: _colorScheme.onSurface,
    ),
    bodyLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: _colorScheme.onSurface,
    ),
    bodyMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: _colorScheme.onSurface,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: _colorScheme.onPrimary,
      backgroundColor: _colorScheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: _colorScheme.primary,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: _colorScheme.primary,
      ),
    ),
    labelStyle: TextStyle(
      color: _colorScheme.primary,
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: _colorScheme.primary,
    foregroundColor: _colorScheme.onPrimary,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: _colorScheme.surface,
    selectedItemColor: _colorScheme.primary,
    unselectedItemColor: _colorScheme.onSurface.withOpacity(0.7),
  ),
);

ThemeData getTheme(BuildContext context) {
  return themeData;
}
