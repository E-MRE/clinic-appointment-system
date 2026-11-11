import 'package:clinic_appointment_system/core/theme/light_theme.dart';
import 'package:clinic_appointment_system/core/theme/screen_size.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/models/appointment_reason_confirmation.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/widgets/appointment_reason_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  final theme = LightTheme(ScreenSize.desktop).themeData;

  Widget buildLauncher({
    required void Function(AppointmentReasonConfirmation? result) onResult,
    String? initialReason,
  }) {
    return Scaffold(
      body: Builder(
        builder: (context) => TextButton(
          onPressed: () async {
            final res = await AppointmentReasonDialog(
              title: 'Talebi reddet',
              subtitle: 'Ali Yılmaz · Sal 27 Eki · Kardiyoloji',
              confirmLabel: 'Reddet',
              initialReason: initialReason,
            ).show(context);
            onResult(res);
          },
          child: const Text('Open'),
        ),
      ),
    );
  }

  testWidgets('renders title, subtitle, helper and action buttons', (
    tester,
  ) async {
    AppointmentReasonConfirmation? result;
    await loadTestTranslations(
      tester,
      theme: theme,
      child: buildLauncher(onResult: (res) => result = res),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Talebi reddet'), findsOneWidget);
    expect(find.text('Ali Yılmaz · Sal 27 Eki · Kardiyoloji'), findsOneWidget);
    expect(find.text('Gerekçe (isteğe bağlı)'), findsOneWidget);
    expect(
      find.text('Gerekçe hastanın randevu kaydında görünür.'),
      findsOneWidget,
    );
    expect(find.text('Vazgeç'), findsOneWidget);
    expect(find.text('Reddet'), findsOneWidget);
    expect(result, isNull);
  });

  testWidgets('returns null on "Vazgeç"', (tester) async {
    AppointmentReasonConfirmation? result;
    bool callbackFired = false;
    await loadTestTranslations(
      tester,
      theme: theme,
      child: buildLauncher(
        onResult: (res) {
          result = res;
          callbackFired = true;
        },
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Vazgeç'));
    await tester.pumpAndSettle();

    expect(callbackFired, isTrue);
    expect(result, isNull);
    expect(find.byType(AppointmentReasonDialog), findsNothing);
  });

  testWidgets('returns trimmed reason on confirm', (tester) async {
    AppointmentReasonConfirmation? result;
    await loadTestTranslations(
      tester,
      theme: theme,
      child: buildLauncher(onResult: (res) => result = res),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byType(TextField),
      '   Doktor acil ameliyatta   ',
    );
    await tester.tap(find.text('Reddet'));
    await tester.pumpAndSettle();

    expect(
      result,
      const AppointmentReasonConfirmation(reason: 'Doktor acil ameliyatta'),
    );
  });

  testWidgets('returns null reason when confirming blank input', (
    tester,
  ) async {
    AppointmentReasonConfirmation? result;
    await loadTestTranslations(
      tester,
      theme: theme,
      child: buildLauncher(onResult: (res) => result = res),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '     ');
    await tester.tap(find.text('Reddet'));
    await tester.pumpAndSettle();

    expect(result, const AppointmentReasonConfirmation(reason: null));
  });

  testWidgets('returns null reason when confirming empty input', (
    tester,
  ) async {
    AppointmentReasonConfirmation? result;
    await loadTestTranslations(
      tester,
      theme: theme,
      child: buildLauncher(onResult: (res) => result = res),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Reddet'));
    await tester.pumpAndSettle();

    expect(result, const AppointmentReasonConfirmation(reason: null));
  });

  testWidgets('populates initialReason when provided', (tester) async {
    AppointmentReasonConfirmation? result;
    await loadTestTranslations(
      tester,
      theme: theme,
      child: buildLauncher(
        initialReason: 'Önceden girilen gerekçe',
        onResult: (res) => result = res,
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.text('Önceden girilen gerekçe'), findsOneWidget);

    await tester.tap(find.text('Reddet'));
    await tester.pumpAndSettle();

    expect(
      result,
      const AppointmentReasonConfirmation(reason: 'Önceden girilen gerekçe'),
    );
  });
}
