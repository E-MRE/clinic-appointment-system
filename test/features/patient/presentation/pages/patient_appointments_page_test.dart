import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/widgets/status_badge/status_badge.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/patient/presentation/pages/patient_book_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../doubles/patient_page_harness.dart';

void main() {
  const fixtures = PatientPageHarness.fixtures;
  late PatientPageHarness harness;

  setUp(() async {
    harness = PatientPageHarness();
    await harness.initialize();
  });

  Future<GoRouter> pumpLoaded(
    WidgetTester tester, {
    Size size = PatientPageHarness.desktop,
    bool dark = false,
  }) async {
    addTearDown(() => harness.dispose(tester));
    final router = createAppRouter(
      initialLocation: AppRoutes.patientAppointments,
    );
    addTearDown(router.dispose);
    await harness.pumpRouter(tester, router, size: size, dark: dark);
    await harness.load(tester);
    return router;
  }

  Finder badge(String label) {
    return find.descendant(
      of: find.byType(StatusBadge),
      matching: find.text(label),
    );
  }

  Future<void> openDetails(WidgetTester tester, int row) async {
    final chevron = find.byTooltip('Randevu ayrıntıları').at(row);
    await tester.ensureVisible(chevron);
    await tester.tap(chevron);
    await tester.pumpAndSettle();
  }

  for (final dark in [false, true]) {
    testWidgets('desktop shows every section (dark: $dark)', (tester) async {
      await pumpLoaded(tester, dark: dark);
      expect(find.text('Merhaba Elif, 3 yaklaşan randevunuz var.'), findsOne);
      expect(find.text('SIRADAKİ RANDEVU'), findsOneWidget);
      expect(find.text('EKİ'), findsOneWidget);
      expect(find.text('26'), findsOneWidget);
      expect(find.text('Pazartesi'), findsOneWidget);
      expect(
        find.text(
          'Dr. Ayşe Yılmaz · 10:40–11:00 (20 dk) · '
          'Merkez Şube, Kardiyoloji · ₺1.200',
        ),
        findsOneWidget,
      );
      expect(find.text('Tümü (7)'), findsOneWidget);
      expect(find.text('Yaklaşan (3)'), findsOneWidget);
      expect(find.text('Geçmiş (4)'), findsOneWidget);
      expect(find.text('26 Eki, 10:40'), findsOneWidget);
      expect(find.text('22 Eyl, 08:30'), findsOneWidget);
      expect(badge('Onaylandı'), findsNWidgets(2));
      expect(badge('Beklemede'), findsNWidgets(2));
      expect(badge('Tamamlandı'), findsOneWidget);
      expect(badge('Gelmedi'), findsOneWidget);
      expect(badge('Reddedildi'), findsOneWidget);
      expect(badge('İptal Edildi'), findsOneWidget);
      expect(find.text('Sizin tarafınızdan iptal edildi'), findsOneWidget);
      expect(find.text('Hazırlık notları'), findsOneWidget);
      expect(find.text('Lipid Paneli · 28 Eki'), findsOneWidget);
      expect(find.text('8–12 saat aç gelin. Su içebilirsiniz.'), findsOne);
      expect(find.text('Akciğer Grafisi · 30 Eki'), findsOneWidget);
      expect(find.text('Metal takı ve aksesuarları çıkarın.'), findsOne);
      expect(find.text('Bölümler'), findsOneWidget);
      expect(find.text('Kardiyoloji'), findsOneWidget);
      expect(find.text('1 hizmet'), findsNWidgets(4));
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Geçmiş shows only past rows, latest first', (tester) async {
    await pumpLoaded(tester);
    await tester.tap(find.text('Geçmiş (4)'));
    await tester.pumpAndSettle();
    expect(find.text('26 Eki, 10:40'), findsNothing);
    expect(find.text('28 Eki, 08:30'), findsNothing);
    final dates = ['12 Eki, 09:20', '5 Eki, 11:00', '29 Eyl, 15:00'];
    for (final date in dates) {
      expect(find.text(date), findsOneWidget);
    }
    expect(
      tester.getTopLeft(find.text(dates.first)).dy,
      lessThan(tester.getTopLeft(find.text(dates.last)).dy),
    );
    expect(find.text('Sizin tarafınızdan iptal edildi'), findsOneWidget);
  });

  testWidgets('details of a past appointment offer no cancel', (tester) async {
    await pumpLoaded(tester);
    await openDetails(tester, 3);
    expect(find.text('Dahiliye Muayenesi'), findsWidgets);
    expect(find.text('Tarih ve saat'), findsOneWidget);
    expect(find.text('12 Ekim 2026 · 09:20–09:40'), findsOneWidget);
    expect(find.text('Randevuyu iptal et'), findsNothing);
    await tester.tap(find.text('Kapat'));
    await tester.pumpAndSettle();
    expect(find.text('Tarih ve saat'), findsNothing);
  });

  testWidgets('confirmed cancel calls the patient cancel and closes', (
    tester,
  ) async {
    await pumpLoaded(tester);
    await openDetails(tester, 0);
    await tester.tap(find.text('Randevuyu iptal et'));
    await tester.pumpAndSettle();
    expect(
      find.text('Bu randevuyu iptal etmek istediğinize emin misiniz?'),
      findsOneWidget,
    );
    await tester.tap(find.text('Vazgeç'));
    await tester.pumpAndSettle();
    expect(harness.appointments.changedIds, isEmpty);

    await tester.tap(find.text('Randevuyu iptal et'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('İptal et'),
      ),
    );
    await harness.flush(tester);
    expect(harness.appointments.changedIds, ['a1']);
    expect(
      harness.appointments.changeResults.single.appointment?.status,
      AppointmentStatus.cancelledByPatient,
    );
    expect(find.text('Randevunuz iptal edildi.'), findsOneWidget);
    expect(find.text('Tarih ve saat'), findsNothing);
  });

  testWidgets('a failed cancel shows the localized error in the dialog', (
    tester,
  ) async {
    await pumpLoaded(tester);
    harness.appointments.failure = AppointmentErrorCode.notFound;
    await openDetails(tester, 0);
    await tester.tap(find.text('Randevuyu iptal et'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('İptal et'),
      ),
    );
    await harness.flush(tester);
    expect(find.text('Randevu artık mevcut değil.'), findsOneWidget);
    expect(find.text('Tarih ve saat'), findsOneWidget);
    expect(find.text('Randevunuz iptal edildi.'), findsNothing);
  });

  testWidgets('the next card cancels after confirmation', (tester) async {
    await pumpLoaded(tester);
    await tester.tap(find.widgetWithText(OutlinedButton, 'İptal et'));
    await tester.pumpAndSettle();
    await tester.tap(
      find.descendant(
        of: find.byType(AlertDialog),
        matching: find.text('İptal et'),
      ),
    );
    await harness.flush(tester);
    expect(harness.appointments.changedIds, ['a1']);
    expect(find.text('Randevunuz iptal edildi.'), findsOneWidget);
  });

  testWidgets('a status change on the stream updates the badge', (
    tester,
  ) async {
    await pumpLoaded(tester);
    expect(badge('Onaylandı'), findsNWidgets(2));
    final approved = fixtures.appointment(
      'a2',
      'lipid',
      'zeynep',
      AppointmentStatus.approved,
      DateTime(2026, 10, 28, 8, 30),
      10,
    );
    await tester.runAsync(() async {
      harness.appointments.emit([
        for (final appointment in fixtures.appointments)
          if (appointment.id == 'a2') approved else appointment,
      ]);
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();
    expect(badge('Onaylandı'), findsNWidgets(3));
    expect(badge('Beklemede'), findsOneWidget);
  });

  testWidgets('a department row opens booking for that department', (
    tester,
  ) async {
    final router = await pumpLoaded(tester);
    final row = find.text('Radyoloji');
    await tester.ensureVisible(row);
    await tester.tap(row);
    await tester.pumpAndSettle();
    final uri = router.routeInformationProvider.value.uri;
    expect(uri.path, AppRoutes.patientBook);
    expect(
      uri.queryParameters[AppRoutes.patientBookDepartmentParameter],
      'radiology',
    );
    final page = tester.widget<PatientBookPage>(find.byType(PatientBookPage));
    expect(page.departmentId, 'radiology');
    expect(find.text('Yakında'), findsOneWidget);
  });

  for (final size in [PatientPageHarness.tablet, PatientPageHarness.mobile]) {
    testWidgets('renders one column without overflow at $size', (tester) async {
      await pumpLoaded(tester, size: size);
      expect(tester.takeException(), isNull);
      expect(find.text('SIRADAKİ RANDEVU'), findsOneWidget);
      final notes = find.text('Hazırlık notları');
      await tester.ensureVisible(notes);
      await tester.pumpAndSettle();
      expect(notes, findsOneWidget);
      expect(
        tester.getTopLeft(notes).dy,
        greaterThan(tester.getTopLeft(find.text('Tümü (7)')).dy),
      );
      expect(tester.takeException(), isNull);
    });
  }
}
