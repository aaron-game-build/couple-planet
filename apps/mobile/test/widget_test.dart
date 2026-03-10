// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:couple_planet_mobile/main.dart';
import 'package:couple_planet_mobile/core/app/app_settings_controller.dart';

void main() {
  testWidgets('App boots to login page', (WidgetTester tester) async {
    final settings = AppSettingsController();
    await tester.pumpWidget(CouplePlanetApp(settings: settings));
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNWidgets(2));
  });
}
