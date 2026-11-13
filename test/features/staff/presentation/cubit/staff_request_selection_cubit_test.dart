import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_request_selection_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_request_selection_state.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_request_sort.dart';
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
  group('StaffRequestSelectionCubit', () {
    final req1 = _makeRequest(
      id: 'req_1',
      date: CalendarDate(year: 2026, month: 10, day: 28),
      range: TimeRange(
        start: ClockTime(hour: 9, minute: 0),
        end: ClockTime(hour: 9, minute: 30),
      ),
      requestedAt: DateTime(2026, 10, 26, 12, 0),
    );

    final req2 = _makeRequest(
      id: 'req_2',
      date: CalendarDate(year: 2026, month: 10, day: 29),
      range: TimeRange(
        start: ClockTime(hour: 10, minute: 0),
        end: ClockTime(hour: 10, minute: 30),
      ),
      requestedAt: DateTime(2026, 10, 25, 8, 0),
    );

    final req3 = _makeRequest(
      id: 'req_3',
      date: CalendarDate(year: 2026, month: 10, day: 30),
      range: TimeRange(
        start: ClockTime(hour: 11, minute: 0),
        end: ClockTime(hour: 11, minute: 30),
      ),
      requestedAt: DateTime(2026, 10, 24, 8, 0),
    );

    late StaffRequestSelectionCubit cubit;

    setUp(() => cubit = StaffRequestSelectionCubit());
    tearDown(() => cubit.close());

    test('starts sorted by date with nothing selected', () {
      expect(
        cubit.state,
        const StaffRequestSelectionState(sort: StaffRequestSort.byDate),
      );
    });

    test('syncRequests selects the earliest request by date', () {
      cubit.syncRequests([req3, req2, req1]);
      expect(cubit.state.selectedRequestId, 'req_1');
    });

    test('syncRequests follows the active sort order', () {
      cubit.changeSort(StaffRequestSort.byRequestTime);
      cubit.syncRequests([req1, req2, req3]);
      expect(cubit.state.selectedRequestId, 'req_3');
    });

    test('select chooses a request by id', () {
      cubit.syncRequests([req1, req2]);
      cubit.select('req_2');
      expect(cubit.state.selectedRequestId, 'req_2');
    });

    test('keeps the selection while it is still listed', () {
      cubit.syncRequests([req1, req2, req3]);
      cubit.select('req_3');
      cubit.syncRequests([req2, req3]);
      expect(cubit.state.selectedRequestId, 'req_3');
    });

    test('selects the first remaining request when the selection vanishes', () {
      cubit.syncRequests([req1, req2, req3]);
      cubit.select('req_2');
      cubit.syncRequests([req3, req1]);
      expect(cubit.state.selectedRequestId, 'req_1');
    });

    test('clears the selection when no request is left', () {
      cubit.syncRequests([req1]);
      cubit.syncRequests([]);
      expect(cubit.state.selectedRequestId, isNull);
    });

    test('changeSort keeps the selection', () {
      cubit.syncRequests([req1, req2]);
      cubit.select('req_2');
      cubit.changeSort(StaffRequestSort.byRequestTime);
      expect(
        cubit.state,
        const StaffRequestSelectionState(
          sort: StaffRequestSort.byRequestTime,
          selectedRequestId: 'req_2',
        ),
      );
    });
  });
}
