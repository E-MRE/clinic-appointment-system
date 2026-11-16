import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_request_sort.dart';
import 'package:clinic_appointment_system/features/staff/presentation/services/staff_request_sorter.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

Appointment _makeRequest({
  required String id,
  required CalendarDate date,
  required TimeRange range,
  required DateTime requestedAt,
}) {
  return Appointment.restore(
    id: id,
    patientId: 'patient_$id',
    patientName: 'Hasta $id',
    staffId: 'staff_1',
    branchId: 'branch_1',
    departmentId: 'dept_1',
    serviceId: 'srv_1',
    serviceName: 'Muayene',
    fee: Money.minorUnits(10000),
    date: date,
    range: range,
    status: AppointmentStatus.pending,
    history: [
      AppointmentStatusChange(
        status: AppointmentStatus.pending,
        byUserId: 'patient_$id',
        byRole: UserRole.patient,
        at: requestedAt,
      ),
    ],
  );
}

void main() {
  const sorter = StaffRequestSorter();

  group('StaffRequestSorter', () {
    // apptA: starts earlier (Oct 28 09:00), but requested later (Oct 26 12:00)
    final apptA = _makeRequest(
      id: 'a',
      date: CalendarDate(year: 2026, month: 10, day: 28),
      range: TimeRange(
        start: ClockTime(hour: 9, minute: 0),
        end: ClockTime(hour: 9, minute: 30),
      ),
      requestedAt: DateTime(2026, 10, 26, 12, 0),
    );

    // apptB: starts later (Oct 29 14:00), but requested earlier (Oct 25 08:00)
    final apptB = _makeRequest(
      id: 'b',
      date: CalendarDate(year: 2026, month: 10, day: 29),
      range: TimeRange(
        start: ClockTime(hour: 14, minute: 0),
        end: ClockTime(hour: 14, minute: 30),
      ),
      requestedAt: DateTime(2026, 10, 25, 8, 0),
    );

    test('byDate orders by appointment start time', () {
      final sorted = sorter.sort([apptB, apptA], sort: StaffRequestSort.byDate);

      expect(sorted, [apptA, apptB]);
      expect(sorter.compare(StaffRequestSort.byDate, apptA, apptB), isNegative);
      expect(sorter.compare(StaffRequestSort.byDate, apptB, apptA), isPositive);
    });

    test('byRequestTime orders by the first history entry time', () {
      final sorted = sorter.sort([
        apptA,
        apptB,
      ], sort: StaffRequestSort.byRequestTime);

      expect(sorted, [apptB, apptA]);
      expect(
        sorter.compare(StaffRequestSort.byRequestTime, apptB, apptA),
        isNegative,
      );
      expect(
        sorter.compare(StaffRequestSort.byRequestTime, apptA, apptB),
        isPositive,
      );
    });
  });
}
