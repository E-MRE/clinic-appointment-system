import 'package:clinic_appointment_system/features/appointments/domain/actors/patient_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/patient/presentation/enums/patient_appointments_tab.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/patient_appointments_tab_selection.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_appointment_entry.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_appointments_overview.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_catalog.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';
import '../doubles/patient_fixtures.dart';

void main() {
  const fixtures = PatientFixtures();
  final patient = PatientAppointmentActor(id: fixtures.patient.id);

  PatientAppointmentsOverview overview({
    List<Appointment>? appointments,
    PatientCatalog? catalog,
    DateTime? now,
  }) {
    return PatientAppointmentsOverview(
      appointments: appointments ?? fixtures.appointments,
      catalog: catalog ?? fixtures.catalog,
      now: now ?? fixtures.now,
      patient: patient,
    );
  }

  List<String> ids(Iterable<PatientAppointmentEntry> entries) {
    return [for (final entry in entries) entry.appointment.id];
  }

  test('upcoming ascends, past descends and all puts upcoming first', () {
    final result = overview();
    expect(ids(result.upcoming), ['a1', 'a2', 'a3']);
    expect(ids(result.past), ['a4', 'a5', 'a6', 'a7']);
    expect(ids(result.all), ['a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7']);
    expect(result.next?.appointment.id, 'a1');
    expect(ids(PatientAppointmentsTab.past.select(result)), ids(result.past));
    expect(
      ids(PatientAppointmentsTab.upcoming.select(result)),
      ids(result.upcoming),
    );
    expect(ids(PatientAppointmentsTab.all.select(result)), ids(result.all));
  });

  test('an open appointment starting exactly now is still upcoming', () {
    final start = fixtures.cardiology.startsAt;
    final atStart = overview(appointments: [fixtures.cardiology], now: start);
    expect(ids(atStart.upcoming), ['a1']);

    final afterStart = overview(
      appointments: [fixtures.cardiology],
      now: start.add(const Duration(minutes: 1)),
    );
    expect(afterStart.upcoming, isEmpty);
    expect(ids(afterStart.past), ['a1']);
    expect(afterStart.next, isNull);
  });

  test('closed statuses are past even when they start later', () {
    final futureCancelled = fixtures.appointment(
      'late',
      'cardio-exam',
      'ayse',
      AppointmentStatus.cancelledByStaff,
      DateTime(2026, 11, 3, 9),
      20,
    );
    final result = overview(appointments: [futureCancelled]);
    expect(result.upcoming, isEmpty);
    expect(ids(result.past), ['late']);
  });

  test('cancel follows the domain: open and not started only', () {
    final result = overview();
    final cancellable = {
      for (final entry in result.all) entry.appointment.id: entry.canCancel,
    };
    expect(cancellable, {
      'a1': true,
      'a2': true,
      'a3': true,
      'a4': false,
      'a5': false,
      'a6': false,
      'a7': false,
    });
    final started = overview(
      appointments: [fixtures.cardiology],
      now: fixtures.cardiology.startsAt,
    );
    expect(started.all.single.canCancel, isFalse);
  });

  test('missing catalog records stay null instead of failing', () {
    final result = overview(
      catalog: PatientCatalog(
        branches: const [],
        departments: const [],
        services: const [],
        staff: const [],
      ),
    );
    final entry = result.all.first;
    expect(entry.service, isNull);
    expect(entry.staff, isNull);
    expect(entry.branch, isNull);
    expect(entry.department, isNull);
    expect(entry.preparationNote, isNull);
    expect(result.preparationNotes, isEmpty);
  });

  testWidgets('preparation notes come from upcoming radiology and lab', (
    tester,
  ) async {
    await loadTestTranslations(tester);
    final notes = overview().preparationNotes;
    expect(ids([for (final note in notes) note.entry]), ['a2', 'a3']);
    expect(notes.map((note) => note.note), [
      '8–12 saat aç gelin. Su içebilirsiniz.',
      'Metal takı ve aksesuarları çıkarın.',
    ]);
  });
}
