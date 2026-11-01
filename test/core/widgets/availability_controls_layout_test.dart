import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/widgets/bottom_sheet/app_sheet_actions.dart';
import 'package:clinic_appointment_system/core/widgets/date_field/app_date_field.dart';
import 'package:clinic_appointment_system/core/widgets/message_banner/app_message_banner.dart';
import 'package:clinic_appointment_system/core/widgets/navigation/app_navigation_user_card.dart';
import 'package:clinic_appointment_system/core/widgets/time_field/app_time_field.dart';
import 'package:clinic_appointment_system/core/widgets/time_range_chip/app_time_range_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/localization_test_app.dart';

void main() {
  for (final brightness in Brightness.values) {
    for (final width in [390.0, 1200.0]) {
      testWidgets('shared controls fit at $width in $brightness', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 900);
        final screen = BreakpointsConstants.resolve(width, 900);
        final theme = brightness == Brightness.light
            ? LightTheme(screen).themeData
            : DarkTheme(screen).themeData;
        final date = CalendarDate(year: 2026, month: 11, day: 2);
        await loadTestTranslations(
          tester,
          theme: theme,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  AppTimeField(
                    label: 'Time',
                    value: null,
                    hint: 'Choose',
                    onChanged: (_) {},
                  ),
                  AppDateField(
                    label: 'Date',
                    value: date,
                    first: date,
                    last: date,
                    onChanged: (_) {},
                  ),
                  const AppTimeRangeChip(
                    label: '09:00–12:00',
                    removeTooltip: 'Remove',
                    onRemove: null,
                  ),
                  for (final variant in AppMessageBannerVariant.values)
                    AppMessageBanner(message: 'Message', variant: variant),
                  AppSheetActions(
                    cancelLabel: 'Cancel',
                    confirmLabel: 'Save',
                    onCancel: () {},
                    onConfirm: () {},
                  ),
                  AppNavigationUserCard(
                    initials: 'AB',
                    name: 'User',
                    subtitle: 'Doctor',
                    signOutTooltip: 'Sign out',
                    onSignOut: () {},
                  ),
                ],
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
        expect(find.byType(AppMessageBanner), findsNWidgets(3));
      });
    }
  }
}
