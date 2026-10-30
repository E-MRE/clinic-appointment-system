import 'package:clinic_appointment_system/core/theme/dark_theme.dart';
import 'package:clinic_appointment_system/core/theme/screen_size.dart';
import 'package:clinic_appointment_system/core/widgets/avatar/app_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders each diameter in dark theme at 2x text scale', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    await tester.pumpWidget(
      MaterialApp(
        theme: DarkTheme(ScreenSize.mobile).themeData,
        home: const MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Row(
            children: [
              AppAvatar(initials: 'AB', size: AppAvatarSize.small),
              AppAvatar(initials: 'CD', size: AppAvatarSize.medium),
              AppAvatar(initials: 'EF', size: AppAvatarSize.large),
            ],
          ),
        ),
      ),
    );

    expect(tester.getSize(find.byType(AppAvatar).at(0)).width, 32);
    expect(tester.getSize(find.byType(AppAvatar).at(1)).width, 40);
    expect(tester.getSize(find.byType(AppAvatar).at(2)).width, 48);
    expect(tester.takeException(), isNull);
  });
}
