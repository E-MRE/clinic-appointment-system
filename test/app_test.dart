import 'package:clinic_appointment_system/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the clinic appointment system title', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());

    expect(find.text('Clinic Appointment System'), findsOneWidget);
  });

  testWidgets('theme toggle switches between light and dark', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const App());
    MaterialApp app() => tester.widget<MaterialApp>(find.byType(MaterialApp));

    expect(app().themeMode, ThemeMode.light);

    await tester.tap(find.byKey(const Key('theme_toggle')));
    await tester.pump();
    expect(app().themeMode, ThemeMode.dark);

    await tester.tap(find.byKey(const Key('theme_toggle')));
    await tester.pump();
    expect(app().themeMode, ThemeMode.light);
  });
}
