import "package:flutter/material.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:flutter/services.dart";

import "app_theme.dart";

class AppSettingsController extends ChangeNotifier {
  AppSettingsController({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const _localeKey = "app_locale";
  static const _themeKey = "app_theme";

  final FlutterSecureStorage _storage;

  Locale _locale = const Locale("zh");
  AppThemeMode _themeMode = AppThemeMode.pink;

  Locale get locale => _locale;
  AppThemeMode get themeMode => _themeMode;

  Future<void> load() async {
    final savedLocale = await _safeRead(_localeKey);
    final savedTheme = await _safeRead(_themeKey);
    _locale = savedLocale == "en" ? const Locale("en") : const Locale("zh");
    _themeMode = AppTheme.fromStorage(savedTheme);
    notifyListeners();
  }

  Future<void> setLocale(Locale next) async {
    _locale = next;
    await _safeWrite(_localeKey, next.languageCode);
    notifyListeners();
  }

  Future<void> setTheme(AppThemeMode next) async {
    _themeMode = next;
    await _safeWrite(_themeKey, AppTheme.toStorage(next));
    notifyListeners();
  }

  Future<String?> _safeRead(String key) async {
    try {
      return await _storage.read(key: key);
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  Future<void> _safeWrite(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } on MissingPluginException {
      // Ignore transient plugin registration issues after hot restart.
    } on PlatformException {
      // Ignore transient plugin registration issues after hot restart.
    }
  }
}
