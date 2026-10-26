import 'package:clinic_appointment_system/core/theme/breakpoints.dart';
import 'package:clinic_appointment_system/core/theme/dark_theme.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_choice_controls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('chips and segments select in dark theme at 2x text scale', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    String? chipSelection;
    String? segmentSelection;
    const choices = [
      AppChoice(value: 'all', label: 'All'),
      AppChoice(value: 'open', label: 'Open appointments'),
    ];
    await tester.pumpWidget(
      MaterialApp(
        theme: DarkTheme(ScreenSize.mobile).themeData,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: Column(
              children: [
                AppFilterChips<String>(
                  choices: choices,
                  selected: 'all',
                  onSelected: (value) => chipSelection = value,
                ),
                AppSegmentedControl<String>(
                  choices: const [
                    AppChoice(value: 'all', label: 'All'),
                    AppChoice(value: 'open', label: 'Open'),
                  ],
                  selected: 'all',
                  onSelected: (value) => segmentSelection = value,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Open appointments'));
    await tester.tap(find.text('Open'));
    expect(chipSelection, 'open');
    expect(segmentSelection, 'open');
    expect(tester.takeException(), isNull);
  });
}
