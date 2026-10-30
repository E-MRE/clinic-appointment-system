import 'package:clinic_appointment_system/core/theme/dark_theme.dart';
import 'package:clinic_appointment_system/core/theme/screen_size.dart';
import 'package:clinic_appointment_system/core/widgets/list_tile/app_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('dense and regular rows expose at least 48px tap areas', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    bool tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: DarkTheme(ScreenSize.mobile).themeData,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: Column(
              children: [
                AppListTile(
                  title: 'Regular patient',
                  subtitle: 'Appointment details',
                  onTap: () {
                    tapped = true;
                  },
                ),
                AppListTile(
                  title: 'Dense patient',
                  density: AppListTileDensity.dense,
                  onTap: () {},
                ),
                const AppListTile(title: 'Static row'),
              ],
            ),
          ),
        ),
      ),
    );

    final targets = tester.widgetList<InkWell>(find.byType(InkWell)).toList();
    expect(targets.length, 3);
    expect(
      tester.getSize(find.byType(InkWell).at(0)).height,
      greaterThanOrEqualTo(48),
    );
    expect(
      tester.getSize(find.byType(InkWell).at(1)).height,
      greaterThanOrEqualTo(48),
    );
    expect(targets.first.onTap, isNotNull);
    expect(targets.last.onTap, isNull);
    await tester.tap(find.text('Regular patient'));
    expect(tapped, isTrue);
    expect(tester.takeException(), isNull);
  });
}
