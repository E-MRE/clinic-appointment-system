import 'package:clinic_appointment_system/core/router/app_router.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/calendar_date_week.dart';
import 'package:clinic_appointment_system/features/patient/presentation/pages/patient_appointments_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../doubles/patient_appointment_repository.dart';
import '../doubles/patient_page_harness.dart';

void main() {
  const fixtures = PatientPageHarness.fixtures;
  final tuesday = fixtures.weekStart.addDays(1);
  final wednesday = fixtures.weekStart.addDays(2);
  late PatientPageHarness harness;

  setUp(() async {
    harness = PatientPageHarness();
    await harness.initialize();
  });

  Future<GoRouter> pumpBook(
    WidgetTester tester, {
    Size size = PatientPageHarness.desktop,
    bool dark = false,
    String location = AppRoutes.patientBook,
  }) async {
    addTearDown(() => harness.dispose(tester));
    final router = createAppRouter(initialLocation: location);
    addTearDown(router.dispose);
    await harness.pumpRouter(tester, router, size: size, dark: dark);
    await harness.load(tester);
    return router;
  }

  Future<void> tapText(WidgetTester tester, String text) async {
    final target = find.text(text).first;
    await tester.ensureVisible(target);
    await tester.tap(target);
    await tester.pump();
  }

  /// Emits Murat's availability and the booked slots of [weekStart]'s days.
  Future<void> loadSchedule(
    WidgetTester tester, {
    CalendarDate? weekStart,
  }) async {
    final start = weekStart ?? fixtures.weekStart;
    await tester.runAsync(() async {
      harness.availability.emit(fixtures.muratAvailability);
      for (int offset = 0; offset < 6; offset++) {
        final date = start.addDays(offset);
        harness.appointments.bookedSlots
            .emit(PatientAppointmentRepository.bookedSlotsKey('murat', date), [
              if (date == tuesday)
                fixtures.booked('t', date, fixtures.range(9, 20, 20)),
              if (date == wednesday)
                fixtures.booked('w', date, fixtures.range(9, 0, 40)),
            ]);
      }
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();
  }

  Future<void> chooseMurat(WidgetTester tester) async {
    await tapText(tester, 'Dahiliye Muayenesi');
    await tester.pumpAndSettle();
    await tapText(tester, 'Dr. Murat Şahin');
    await loadSchedule(tester);
  }

  FilledButton submitButton(WidgetTester tester) {
    return tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Randevu talep et'),
    );
  }

  AppText appText(WidgetTester tester, String text) {
    return tester.widget<AppText>(
      find.byWidgetPredicate(
        (widget) => widget is AppText && widget.data == text,
      ),
    );
  }

  for (final dark in [false, true]) {
    testWidgets('desktop booking flow fills the summary (dark: $dark)', (
      tester,
    ) async {
      await pumpBook(tester, dark: dark);
      expect(
        find.text(
          'Hizmeti ve doktoru seçin, uygun saatlerden birini işaretleyin.',
        ),
        findsOneWidget,
      );
      expect(find.text('Dahiliye Muayenesi'), findsOneWidget);
      expect(find.text('Muayene · 20 dk · ₺900'), findsOneWidget);
      expect(find.text('Dahiliye'), findsOneWidget);
      expect(find.text('Metal takı ve aksesuarları çıkarın.'), findsOneWidget);
      expect(find.text('8–12 saat aç gelin. Su içebilirsiniz.'), findsOne);
      expect(find.text('Önce bir hizmet seçin.'), findsOneWidget);
      expect(find.text('Saatleri görmek için bir doktor seçin.'), findsOne);
      expect(find.text('19 – 24 Ekim'), findsOneWidget);
      expect(find.text('—'), findsNWidgets(6));
      expect(submitButton(tester).onPressed, isNull);

      await tapText(tester, 'Dahiliye Muayenesi');
      await tester.pumpAndSettle();
      expect(find.text('Dr. Murat Şahin'), findsOneWidget);
      expect(find.text('Dahiliye · Merkez Şube'), findsOneWidget);
      expect(find.text('Dr. Ayşe Yılmaz'), findsNothing);
      expect(find.text('Merkez Şube · Dahiliye'), findsOneWidget);

      await tapText(tester, 'Dr. Murat Şahin');
      await loadSchedule(tester);
      expect(find.text('Kapalı'), findsNWidgets(3));
      expect(find.text('2 boş'), findsOneWidget);
      expect(find.text('Dolu'), findsOneWidget);
      expect(find.text('12 boş'), findsOneWidget);
      expect(find.text('Sabah · 08:00–10:00'), findsOneWidget);
      expect(find.text('09:00'), findsOneWidget);
      expect(
        find.text(
          'Yalnızca Dr. Murat Şahin adlı personelin uygun olduğu saatler '
          'listelenir. Üstü çizili saatler dolu.',
        ),
        findsOneWidget,
      );
      expect(appText(tester, '09:20').decoration, TextDecoration.lineThrough);
      expect(submitButton(tester).onPressed, isNull);

      await tapText(tester, '09:20');
      await tester.pumpAndSettle();
      expect(submitButton(tester).onPressed, isNull);

      await tapText(tester, '09:40');
      await tester.pumpAndSettle();
      expect(find.text('Salı 20 Ekim · 09:40–10:00'), findsOneWidget);
      expect(submitButton(tester).onPressed, isNotNull);

      await tapText(tester, '22');
      await tester.pumpAndSettle();
      expect(find.text('Sabah · 09:00–12:00'), findsOneWidget);
      expect(find.text('Öğleden sonra · 13:30–14:30'), findsOneWidget);
      expect(submitButton(tester).onPressed, isNull);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('submitting books the slot and opens Randevularım', (
    tester,
  ) async {
    final router = await pumpBook(tester);
    await chooseMurat(tester);
    await tapText(tester, '09:40');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Randevu talep et'));
    await harness.flush(tester);

    final candidate = harness.appointments.bookedCandidates.single;
    expect(candidate.patientId, fixtures.patient.id);
    expect(candidate.staffId, 'murat');
    expect(candidate.branchId, 'branch');
    expect(candidate.departmentId, 'internal');
    expect(candidate.serviceId, 'internal-exam');
    expect(candidate.serviceName, 'Dahiliye Muayenesi');
    expect(candidate.fee, fixtures.services[1].fee);
    expect(candidate.date, tuesday);
    expect(candidate.range, fixtures.range(9, 40, 20));
    expect(candidate.status, AppointmentStatus.pending);
    expect(find.text('Randevu talebiniz alındı.'), findsOneWidget);
    expect(
      router.routeInformationProvider.value.uri.path,
      AppRoutes.patientAppointments,
    );
    expect(find.byType(PatientAppointmentsPage), findsOneWidget);
  });

  testWidgets('an overlap shows the error and clears the slot', (tester) async {
    harness.appointments.bookFailure = AppointmentErrorCode.staffOverlap;
    final router = await pumpBook(tester);
    await chooseMurat(tester);
    await tapText(tester, '09:40');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Randevu talep et'));
    await harness.flush(tester);

    expect(
      find.text('Bu saat artık dolu. Lütfen başka bir saat seçin.'),
      findsOneWidget,
    );
    expect(find.text('Salı 20 Ekim · 09:40–10:00'), findsNothing);
    expect(submitButton(tester).onPressed, isNull);
    expect(
      router.routeInformationProvider.value.uri.path,
      AppRoutes.patientBook,
    );
  });

  testWidgets('week navigation stops at the current week', (tester) async {
    await pumpBook(tester);
    await chooseMurat(tester);
    IconButton previousWeek() {
      return tester.widget<IconButton>(
        find.widgetWithIcon(IconButton, Icons.chevron_left),
      );
    }

    expect(previousWeek().onPressed, isNull);
    await tester.tap(find.byTooltip('Sonraki hafta'));
    await tester.pump();
    final nextMonday = fixtures.weekStart.addDays(7);
    expect(
      harness.appointments.bookedSlots.requested,
      contains(
        PatientAppointmentRepository.bookedSlotsKey('murat', nextMonday),
      ),
    );
    await loadSchedule(tester, weekStart: nextMonday);
    expect(find.text('26 – 31 Ekim'), findsOneWidget);
    expect(find.text('Kapalı'), findsNWidgets(2));
    expect(previousWeek().onPressed, isNotNull);
    expect(find.text('Pzt'), findsOneWidget);
  });

  testWidgets('a department link limits services until removed', (
    tester,
  ) async {
    await pumpBook(
      tester,
      location: AppRoutes.patientBookForDepartment('cardio'),
    );
    expect(find.text('Kardiyoloji'), findsNWidgets(2));
    expect(find.text('Kardiyoloji Muayenesi'), findsOneWidget);
    expect(find.text('Dahiliye Muayenesi'), findsNothing);
    await tester.tap(find.byTooltip('Bölüm filtresini kaldır'));
    await tester.pumpAndSettle();
    expect(find.text('Dahiliye Muayenesi'), findsOneWidget);
    expect(find.byTooltip('Bölüm filtresini kaldır'), findsNothing);
  });

  testWidgets('searching filters services by name', (tester) async {
    await pumpBook(tester);
    await tester.enterText(find.byType(TextField), 'lipid');
    await tester.pumpAndSettle();
    expect(find.text('Lipid Paneli'), findsOneWidget);
    expect(find.text('Dahiliye Muayenesi'), findsNothing);
    await tester.enterText(find.byType(TextField), 'yok');
    await tester.pumpAndSettle();
    expect(find.text('Aramanızla eşleşen hizmet yok.'), findsOneWidget);
  });

  for (final size in [PatientPageHarness.tablet, PatientPageHarness.mobile]) {
    testWidgets('renders one column without overflow at $size', (tester) async {
      await pumpBook(tester, size: size);
      await chooseMurat(tester);
      await tapText(tester, '09:40');
      await tester.pumpAndSettle();
      expect(find.text('Salı 20 Ekim · 09:40–10:00'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
