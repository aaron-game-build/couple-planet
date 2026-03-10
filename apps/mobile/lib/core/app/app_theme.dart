import "package:flutter/material.dart";

enum AppThemeMode {
  light,
  dark,
  pink,
}

class AppTheme {
  static ThemeData resolve(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: Colors.blue,
          useMaterial3: true,
        );
      case AppThemeMode.dark:
        return ThemeData(
          brightness: Brightness.dark,
          colorSchemeSeed: Colors.blueGrey,
          useMaterial3: true,
        );
      case AppThemeMode.pink:
        return ThemeData(
          brightness: Brightness.light,
          colorSchemeSeed: Colors.pink,
          useMaterial3: true,
        );
    }
  }

  static String toStorage(AppThemeMode mode) => mode.name;

  static AppThemeMode fromStorage(String? value) {
    return AppThemeMode.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AppThemeMode.pink,
    );
  }
}
