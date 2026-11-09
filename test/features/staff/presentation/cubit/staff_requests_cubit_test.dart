import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_staff_appointments_use_case.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_requests_cubit.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_requests_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../../../appointments/domain/support/appointment_fixture.dart';
import '../../../appointments/presentation/doubles/staff_appointment_repository.dart';

void main() {
  const fixture = AppointmentFixture();
  late StaffAppointmentRepository repository;
  late StaffRequestsCubit cubit;

  setUp(() {
    repository = StaffAppointmentRepository();
    cubit = StaffRequestsCubit(
      WatchStaffAppointmentsUseCase(repository),
      FixedClock(DateTime(2026, 12, 15, 23, 5)),
    );
  });

  tearDown(() async {
    await cubit.close();
    await repository.events.close();
  });

  test('watches from today through sixty days ahead, inclusive', () {
    cubit.watch('staff-7');

    expect(repository.watchedQueries, [
      (
        'staff-7',
        CalendarDate(year: 2026, month: 12, day: 15),
        CalendarDate(year: 2027, month: 2, day: 13),
      ),
    ]);
  });

  test(
    'keeps pending appointments sorted by start and updates on emissions',
    () async {
      cubit.watch('staff-7');
      final later = _appointment(
        fixture,
        id: 'later',
        status: AppointmentStatus.pending,
        startsAt: DateTime(2026, 12, 20, 10),
      );
      final earlier = _appointment(
        fixture,
        id: 'earlier',
        status: AppointmentStatus.pending,
        startsAt: DateTime(2026, 12, 20, 9),
      );
      final approved = _appointment(
        fixture,
        id: 'approved',
        status: AppointmentStatus.approved,
        startsAt: DateTime(2026, 12, 20, 8),
      );

      repository.emit([later, approved, earlier]);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, isA<StaffRequestsLoaded>());
      expect(
        (cubit.state as StaffRequestsLoaded).requests.map((item) => item.id),
        ['earlier', 'later'],
      );

      final newest = _appointment(
        fixture,
        id: 'newest',
        status: AppointmentStatus.pending,
        startsAt: DateTime(2026, 12, 21, 8),
      );
      repository.emit([approved, newest]);
      await Future<void>.delayed(Duration.zero);

      expect(
        (cubit.state as StaffRequestsLoaded).requests.map((item) => item.id),
        ['newest'],
      );
    },
  );

  test(
    'preserves typed failures and maps stream errors to unavailable',
    () async {
      cubit.watch('staff-7');
      repository.events.add(
        const DataResult<List<Appointment>>.error(
          errorCode: AppointmentErrorCode.notFound,
        ),
      );
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state, isA<StaffRequestsFailure>());
      expect(
        (cubit.state as StaffRequestsFailure).errorCode,
        AppointmentErrorCode.notFound,
      );

      repository.events.addError(StateError('stream failed'));
      await Future<void>.delayed(Duration.zero);
      expect(cubit.state, isA<StaffRequestsFailure>());
      expect(
        (cubit.state as StaffRequestsFailure).errorCode,
        AppointmentErrorCode.unavailable,
      );
    },
  );

  test('ignores emissions after close', () async {
    cubit.watch('staff-7');
    await cubit.close();
    repository.emit([
      _appointment(
        fixture,
        id: 'pending',
        status: AppointmentStatus.pending,
        startsAt: DateTime(2026, 12, 20, 9),
      ),
    ]);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state, isA<StaffRequestsLoading>());
  });
}

Appointment _appointment(
  AppointmentFixture fixture, {
  required String id,
  required AppointmentStatus status,
  required DateTime startsAt,
}) {
  final start = ClockTime(hour: startsAt.hour, minute: startsAt.minute);
  return Appointment.restore(
    id: id,
    patientId: 'patient-7',
    staffId: 'staff-7',
    branchId: 'branch-1',
    departmentId: 'department-1',
    serviceId: 'service-1',
    serviceName: 'Examination',
    fee: fixture.fee,
    date: CalendarDate.fromDateTime(startsAt),
    range: TimeRange(
      start: start,
      end: ClockTime.fromMinutes(start.minutesSinceMidnight + 30),
    ),
    status: status,
    history: [fixture.change(status)],
  );
}
