import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/staff/presentation/widgets/staff_appointment_dialog.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../appointments/domain/support/appointment_fixture.dart';
import '../pages/doubles/staff_requests_page_harness.dart';

void main() {
  const fixture = AppointmentFixture();
  final staff = fixture.actor(UserRole.doctor, 'staff');

  Appointment approvedAppointment({String id = 'appointment-dialog'}) {
    final appointment = fixture.request(patientName: 'Ada Yılmaz').withId(id);
    return fixture
        .success(appointment.approve(by: staff, at: fixture.beforeStart))
        .withId(id);
  }

  Future<void> openDialog(
    WidgetTester tester,
    StaffRequestsPageHarness harness,
    Appointment appointment, {
    Size size = StaffRequestsPageHarness.desktop,
  }) async {
    await harness.pumpDialog(tester, appointment, size: size);
    await tester.tap(find.text('Open appointment'));
    await tester.pumpAndSettle();
    expect(find.byType(StaffAppointmentDialog), findsOneWidget);
  }

  testWidgets('shows patient, status, schedule, service, fee and location', (
    tester,
  ) async {
    final harness = StaffRequestsPageHarness();
    await harness.initialize();
    addTearDown(() => harness.dispose(tester));
    final appointment = fixture
        .request(patientName: 'Ada Yılmaz')
        .withId('appointment-details');

    await openDialog(tester, harness, appointment);

    expect(find.text('Ada Yılmaz'), findsOneWidget);
    expect(find.text('Beklemede'), findsOneWidget);
    expect(find.text('Tarih ve saat'), findsOneWidget);
    expect(find.text('Hizmet'), findsOneWidget);
    expect(find.text('Examination'), findsOneWidget);
    expect(find.text('Süre ve ücret'), findsOneWidget);
    expect(find.text('Yer'), findsOneWidget);
    expect(find.text('Merkez Şube · Cardiology'), findsOneWidget);
  });

  testWidgets('Tamamlandı performs complete and closes with feedback', (
    tester,
  ) async {
    final harness = StaffRequestsPageHarness(now: fixture.start);
    await harness.initialize();
    addTearDown(() => harness.dispose(tester));
    final appointment = approvedAppointment();
    harness.repository.stored[appointment.id] = appointment;

    await openDialog(tester, harness, appointment);
    await tester.tap(find.widgetWithText(FilledButton, 'Tamamlandı'));
    await tester.pumpAndSettle();

    expect(harness.repository.changedIds, [appointment.id]);
    expect(
      harness.repository.stored[appointment.id]?.status,
      AppointmentStatus.completed,
    );
    expect(find.byType(StaffAppointmentDialog), findsNothing);
    expect(find.text('Randevu tamamlandı olarak işaretlendi.'), findsOneWidget);
  });

  testWidgets('staff cancel opens reason dialog and forwards the reason', (
    tester,
  ) async {
    final harness = StaffRequestsPageHarness(now: fixture.beforeStart);
    await harness.initialize();
    addTearDown(() => harness.dispose(tester));
    final appointment = approvedAppointment();
    harness.repository.stored[appointment.id] = appointment;

    await openDialog(tester, harness, appointment);
    await tester.tap(find.text('İptal et…'));
    await tester.pumpAndSettle();
    expect(find.text('Randevuyu iptal et'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Şube saatleri değişti');
    await tester.tap(find.text('İptal et'));
    await tester.pumpAndSettle();

    expect(harness.repository.changedIds, [appointment.id]);
    expect(
      harness.repository.stored[appointment.id]?.status,
      AppointmentStatus.cancelledByStaff,
    );
    expect(
      harness.repository.stored[appointment.id]?.statusReason,
      'Şube saatleri değişti',
    );
    expect(find.byType(StaffAppointmentDialog), findsNothing);
    expect(find.text('Randevu iptal edildi.'), findsOneWidget);
  });

  testWidgets('disabled actions show the too-early tolerance hints', (
    tester,
  ) async {
    final harness = StaffRequestsPageHarness(now: fixture.beforeStart);
    await harness.initialize();
    addTearDown(() => harness.dispose(tester));

    await openDialog(
      tester,
      harness,
      approvedAppointment(),
      size: StaffRequestsPageHarness.mobile,
    );

    expect(find.text('Randevu saati gelince işaretlenebilir.'), findsOneWidget);
    expect(
      find.text('"Gelmedi" 10:15\'te açılır (15 dk tolerans).'),
      findsOneWidget,
    );
    final noShowButton = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, 'Gelmedi'),
    );
    expect(noShowButton.onPressed, isNull);
    expect(tester.takeException(), isNull);
  });

  testWidgets('localized failure stays visible while dialog remains open', (
    tester,
  ) async {
    final harness = StaffRequestsPageHarness(now: fixture.start);
    await harness.initialize();
    addTearDown(() => harness.dispose(tester));
    final appointment = approvedAppointment();
    harness.repository.stored[appointment.id] = appointment;
    harness.repository.changeFailure = AppointmentErrorCode.unavailable;

    await openDialog(tester, harness, appointment);
    await tester.tap(find.widgetWithText(FilledButton, 'Tamamlandı'));
    await tester.pumpAndSettle();

    expect(find.byType(StaffAppointmentDialog), findsOneWidget);
    expect(
      find.text('İşlem şu anda tamamlanamadı. Lütfen tekrar deneyin.'),
      findsOneWidget,
    );
  });

  testWidgets('completed appointment has no lifecycle action buttons', (
    tester,
  ) async {
    final harness = StaffRequestsPageHarness(now: fixture.start);
    await harness.initialize();
    addTearDown(() => harness.dispose(tester));
    final completed = fixture.success(
      approvedAppointment().complete(by: staff, at: fixture.start),
    );

    await openDialog(tester, harness, completed);

    expect(find.byType(FilledButton), findsNothing);
    expect(find.byType(OutlinedButton), findsNothing);
    expect(find.widgetWithText(TextButton, 'İptal et…'), findsNothing);
  });

  testWidgets('shows the reason row for a staff-cancelled appointment', (
    tester,
  ) async {
    final harness = StaffRequestsPageHarness(now: fixture.beforeStart);
    await harness.initialize();
    addTearDown(() => harness.dispose(tester));
    final cancelled = fixture.success(
      approvedAppointment().cancelByStaff(
        by: staff,
        at: fixture.beforeStart,
        reason: 'Hasta ile görüşüldü',
      ),
    );

    await openDialog(tester, harness, cancelled);

    expect(find.text('Gerekçe'), findsOneWidget);
    expect(find.text('Hasta ile görüşüldü'), findsOneWidget);
    expect(find.byType(FilledButton), findsNothing);
    expect(find.byType(OutlinedButton), findsNothing);
  });
}
