import 'package:clinic_appointment_system/core/theme/breakpoints.dart';
import 'package:clinic_appointment_system/core/theme/dark_theme.dart';
import 'package:clinic_appointment_system/core/widgets/select_field/app_select_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('controlled value updates after a parent rebuild', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    Widget field(String value) {
      return MaterialApp(
        theme: DarkTheme(ScreenSize.mobile).themeData,
        home: Scaffold(
          body: AppSelectField<String>(
            label: 'Role',
            fieldKey: const ValueKey('role-field'),
            value: value,
            options: const [
              AppSelectOption(value: 'doctor', label: 'Doctor'),
              AppSelectOption(value: 'patient', label: 'Patient'),
            ],
            onChanged: (_) {},
          ),
        ),
      );
    }

    await tester.pumpWidget(field('doctor'));
    expect(find.text('Doctor'), findsOneWidget);
    await tester.pumpWidget(field('patient'));
    expect(find.text('Patient'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
