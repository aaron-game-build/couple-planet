import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";

import "core/app/app_settings_controller.dart";
import "core/app/app_settings_scope.dart";
import "core/app/app_theme.dart";
import "core/api_client.dart";
import "core/i18n/app_strings.dart";
import "features/auth/login_page.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settings = AppSettingsController();
  await settings.load();
  runApp(CouplePlanetApp(settings: settings));
}

class CouplePlanetApp extends StatefulWidget {
  const CouplePlanetApp({super.key, required this.settings});

  final AppSettingsController settings;

  @override
  State<CouplePlanetApp> createState() => _CouplePlanetAppState();
}

class _CouplePlanetAppState extends State<CouplePlanetApp> {
  late final ApiClient _apiClient;

  @override
  void initState() {
    super.initState();
    _apiClient = ApiClient();
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsScope(
      controller: widget.settings,
      child: AnimatedBuilder(
        animation: widget.settings,
        builder: (_, __) {
          return MaterialApp(
            title: "Couple Planet",
            locale: widget.settings.locale,
            supportedLocales: AppStrings.supportedLocales,
            localizationsDelegates: const [
              AppStrings.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            theme: AppTheme.resolve(widget.settings.themeMode),
            home: LoginPage(apiClient: _apiClient),
          );
        },
      ),
    );
  }
}
