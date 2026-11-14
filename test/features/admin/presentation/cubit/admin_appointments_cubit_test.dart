import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/admin/presentation/cubit/admin_appointments_cubit.dart';
import 'package:clinic_appointment_system/features/admin/presentation/cubit/admin_appointments_state.dart';
import 'package:clinic_appointment_system/features/admin/presentation/enums/admin_status_filter.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_admin_appointments_use_case.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../../../appointments/domain/support/appointment_fixture.dart';
import '../../../appointments/presentation/doubles/staff_appointment_repository.dart';

void main() {
  const fixture = AppointmentFixture();
  late StaffAppointmentRepository repository;
  late AdminAppointmentsCubit cubit;

  setUp(() {
    repository = StaffAppointmentRepository();
    cubit = AdminAppointmentsCubit(
      WatchAdminAppointmentsUseCase(repository),
      FixedClock(DateTime(2026, 11, 1, 12)),
    );
  });

  tearDown(() async {
    await cubit.close();
    await repository.events.close();
  });

  test('subscribes to the current Monday through Sunday range', () {
    expect(repository.watchedAdminQueries, [
      (
        CalendarDate(year: 2026, month: 10, day: 26),
        CalendarDate(year: 2026, month: 11, day: 1),
      ),
    ]);
  });

  test(
    'sorts by date and start time, paginates, counts and resets on filters',
    () async {
      final appointments = [
        for (int index = 0; index < 17; index++)
          _appointment(
            fixture,
            id: 'appointment-$index',
            day: 26 + index ~/ 3,
            hour: 8 + index % 3,
            status: index == 4
                ? AppointmentStatus.approved
                : AppointmentStatus.pending,
            patientName: 'Patient $index',
          ),
      ];
      repository.emit(appointments.reversed.toList());
      await Future<void>.delayed(Duration.zero);

      final loaded = cubit.state as AdminAppointmentsLoaded;
      expect(loaded.allAppointmentsInRange, hasLength(17));
      expect(loaded.currentPageAppointments, hasLength(10));
      expect(loaded.rangeLabel, '1–10 / 17');
      expect(loaded.pageCount, 2);
      expect(loaded.filteredAppointments.first.id, 'appointment-0');
      expect(loaded.filteredAppointments[1].id, 'appointment-1');

      cubit.goToPage(99);
      final lastPage = cubit.state as AdminAppointmentsLoaded;
      expect(lastPage.currentPage, 2);
      expect(lastPage.currentPageAppointments, hasLength(7));
      expect(lastPage.rangeLabel, '11–17 / 17');

      cubit.selectStatuses({AdminStatusFilter.pending});
      final filtered = cubit.state as AdminAppointmentsLoaded;
      expect(filtered.currentPage, 1);
      expect(filtered.filteredAppointments, hasLength(16));
      expect(filtered.currentPageAppointments, hasLength(10));
      expect(filtered.statusCounts[AdminStatusFilter.pending], 16);
      expect(filtered.statusCounts[AdminStatusFilter.approved], 0);
      expect(
        filtered.statusCounts.values.fold<int>(
          0,
          (total, count) => total + count,
        ),
        filtered.filteredAppointments.length,
      );

      cubit.goToPage(2);
      final filteredLastPage = cubit.state as AdminAppointmentsLoaded;
      expect(filteredLastPage.currentPageAppointments, hasLength(6));
      expect(filteredLastPage.rangeLabel, '11–16 / 16');

      cubit.searchPatient('Patient 1');
      final searched = cubit.state as AdminAppointmentsLoaded;
      expect(searched.currentPage, 1);
      expect(searched.filteredAppointments, hasLength(8));
      expect(searched.rangeLabel, '1–8 / 8');

      cubit.clearFilters();
      final cleared = cubit.state as AdminAppointmentsLoaded;
      expect(cleared.filteredAppointments, hasLength(17));
      expect(cleared.currentPage, 1);
    },
  );

  test('only date range changes and explicit retry resubscribe', () async {
    repository.emit([_appointment(fixture, id: 'initial')]);
    await Future<void>.delayed(Duration.zero);

    cubit.selectStatuses({AdminStatusFilter.pending});
    cubit.searchPatient('patient');
    expect(repository.watchedAdminQueries, hasLength(1));

    cubit.selectDateRange(
      CalendarDate(year: 2026, month: 10, day: 19),
      CalendarDate(year: 2026, month: 10, day: 25),
    );
    expect(repository.watchedAdminQueries, hasLength(2));
    expect(repository.watchedAdminQueries.last, (
      CalendarDate(year: 2026, month: 10, day: 19),
      CalendarDate(year: 2026, month: 10, day: 25),
    ));

    cubit.searchPatient('new query');
    expect(repository.watchedAdminQueries, hasLength(2));
    cubit.retry();
    expect(repository.watchedAdminQueries, hasLength(3));
  });

  test('typed and stream failures preserve error codes and retry', () async {
    repository.events.add(
      const DataResult<List<Appointment>>.error(
        errorCode: AppointmentErrorCode.notFound,
      ),
    );
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, isA<AdminAppointmentsFailure>());
    expect(
      (cubit.state as AdminAppointmentsFailure).errorCode,
      AppointmentErrorCode.notFound,
    );

    cubit.retry();
    expect(repository.watchedAdminQueries, hasLength(2));
    repository.events.addError(StateError('stream failed'));
    await Future<void>.delayed(Duration.zero);
    expect(
      (cubit.state as AdminAppointmentsFailure).errorCode,
      AppointmentErrorCode.unavailable,
    );

    cubit.retry();
    repository.emit([]);
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state, isA<AdminAppointmentsLoaded>());
    expect((cubit.state as AdminAppointmentsLoaded).rangeLabel, '0–0 / 0');
  });
}

Appointment _appointment(
  AppointmentFixture fixture, {
  String id = 'appointment',
  int day = 1,
  int hour = 10,
  AppointmentStatus status = AppointmentStatus.pending,
  String patientName = 'Patient',
}) {
  return Appointment.restore(
    id: id,
    patientId: 'patient-1',
    patientName: patientName,
    staffId: 'staff-1',
    branchId: 'branch-1',
    departmentId: 'department-1',
    serviceId: 'service-1',
    serviceName: 'Examination',
    fee: fixture.fee,
    date: CalendarDate(year: 2026, month: 10, day: day),
    range: TimeRange(
      start: ClockTime(hour: hour, minute: 0),
      end: ClockTime(hour: hour, minute: 30),
    ),
    status: status,
    history: [fixture.change(status)],
  );
}
