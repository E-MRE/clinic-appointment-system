import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_patient_history.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

Appointment _makeAppointment({
  required String id,
  required String patientId,
  required String staffId,
  required AppointmentStatus status,
  required CalendarDate date,
  required TimeRange range,
}) {
  return Appointment.restore(
    id: id,
    patientId: patientId,
    patientName: 'Hasta $patientId',
    staffId: staffId,
    branchId: 'branch_1',
    departmentId: 'dept_1',
    serviceId: 'srv_1',
    serviceName: 'Muayene',
    fee: Money.minorUnits(10000),
    date: date,
    range: range,
    status: status,
    history: [
      AppointmentStatusChange(
        status: status,
        byUserId: patientId,
        byRole: UserRole.patient,
        at: DateTime(date.year, date.month, date.day, 8),
      ),
    ],
  );
}

void main() {
  group('StaffPatientHistory', () {
    final range = TimeRange(
      start: ClockTime(hour: 10, minute: 0),
      end: ClockTime(hour: 10, minute: 30),
    );

    test('is empty when given no appointments', () {
      final history = StaffPatientHistory.fromAppointments(
        patientId: 'p1',
        appointments: const [],
      );
      expect(history.hasHistory, isFalse);
      expect(history.completedCount, 0);
      expect(history.latestVisitDate, isNull);
      expect(history.lastVisitLabel, isNull);
    });

    test(
      'counts only completed appointments of the same patient with this staff member',
      () {
        final appts = [
          _makeAppointment(
            id: 'a1',
            patientId: 'p1',
            staffId: 'staff_1',
            status: AppointmentStatus.completed,
            date: CalendarDate(year: 2026, month: 8, day: 10),
            range: range,
          ),
          _makeAppointment(
            id: 'a2',
            patientId: 'p1',
            staffId: 'staff_1',
            status: AppointmentStatus.completed,
            date: CalendarDate(year: 2026, month: 9, day: 14),
            range: range,
          ),
          _makeAppointment(
            id: 'a3',
            patientId: 'p1',
            staffId: 'staff_1',
            status: AppointmentStatus.approved,
            date: CalendarDate(year: 2026, month: 10, day: 1),
            range: range,
          ),
          _makeAppointment(
            id: 'a4',
            patientId: 'p1',
            staffId: 'staff_1',
            status: AppointmentStatus.pending,
            date: CalendarDate(year: 2026, month: 10, day: 5),
            range: range,
          ),
          _makeAppointment(
            id: 'a5',
            patientId: 'p1',
            staffId: 'staff_1',
            status: AppointmentStatus.cancelledByPatient,
            date: CalendarDate(year: 2026, month: 7, day: 1),
            range: range,
          ),
          _makeAppointment(
            id: 'a6',
            patientId: 'p1',
            staffId: 'staff_1',
            status: AppointmentStatus.noShow,
            date: CalendarDate(year: 2026, month: 6, day: 1),
            range: range,
          ),
          // Different patient
          _makeAppointment(
            id: 'a7',
            patientId: 'p2',
            staffId: 'staff_1',
            status: AppointmentStatus.completed,
            date: CalendarDate(year: 2026, month: 9, day: 20),
            range: range,
          ),
        ];

        final history = StaffPatientHistory.fromAppointments(
          patientId: 'p1',
          appointments: appts,
        );

        expect(history.completedCount, 2);
        expect(history.hasHistory, isTrue);
        expect(history.latestVisitDate, DateTime(2026, 9, 14, 10, 0));
      },
    );

    testWidgets('formats completed and latest visit labels', (tester) async {
      await loadTestTranslations(tester);

      final history = StaffPatientHistory(
        completedCount: 3,
        latestVisitDate: DateTime(2026, 9, 14, 10, 0),
      );

      expect(history.completedLabel, '3 tamamlandı');
      expect(history.lastVisitLabel, 'Son ziyaret: 14 Eylül');
    });
  });
}
