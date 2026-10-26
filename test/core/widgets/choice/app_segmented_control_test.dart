import 'package:clinic_appointment_system/core/theme/breakpoints.dart';
import 'package:clinic_appointment_system/core/theme/dark_theme.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_choice.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('segments select in dark theme at 2x text scale', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    String? selection;
    const choices = [
      AppChoice(value: 'all', label: 'All'),
      AppChoice(value: 'open', label: 'Open'),
    ];
    await tester.pumpWidget(
      MaterialApp(
        theme: DarkTheme(ScreenSize.mobile).themeData,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: AppSegmentedControl<String>(
              choices: choices,
              selected: 'all',
              onSelected: (value) => selection = value,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    expect(selection, 'open');
    expect(tester.takeException(), isNull);
  });
}
