import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/features/admin/presentation/cubit/admin_dashboard_cubit.dart';
import 'package:clinic_appointment_system/features/admin/presentation/cubit/admin_dashboard_state.dart';
import 'package:clinic_appointment_system/features/admin/presentation/models/admin_dashboard_summary.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clinic_appointment_system/features/appointments/domain/results/appointment_result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_admin_appointments_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_pending_appointments_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/admin_dashboard_fixture.dart';

void main() {
  const fixture = AdminDashboardFixture();
  late _DashboardAppointmentRepository repository;
  late _TestClock clock;
  late AdminDashboardCubit cubit;

  Future<void> flush() => Future<void>.delayed(Duration.zero);

  AdminDashboardSummary summary() {
    final state = cubit.state;
    if (state is! AdminDashboardLoaded) {
      fail('Expected a loaded dashboard summary.');
    }
    return state.summary;
  }

  setUp(() {
    repository = _DashboardAppointmentRepository();
    clock = _TestClock(DateTime(2026, 11, 14, 23, 30));
    cubit = AdminDashboardCubit(
      WatchAdminAppointmentsUseCase(repository),
      WatchPendingAppointmentsUseCase(repository),
      clock,
    );
  });

  tearDown(() async {
    await cubit.close();
    await repository.close();
  });

  test(
    'waits for both appointment streams and recomputes on each change',
    () async {
      expect(cubit.state, isA<AdminDashboardLoading>());
      expect(repository.watchedAdminQueries, hasLength(1));
      expect(repository.watchedAdminQueries.single.$1, fixture.calendarDay);
      expect(repository.watchedAdminQueries.single.$2, fixture.calendarDay);

      cubit.updateCatalog(fixture.catalog);
      final firstToday = fixture.appointment(
        id: 'complete',
        status: AppointmentStatus.completed,
      );
      repository.emitToday([firstToday]);
      await flush();
      expect(cubit.state, isA<AdminDashboardLoading>());

      repository.emitPending(const []);
      await flush();
      expect(summary().todayAppointmentCount, 1);
      expect(summary().completedCount, 1);

      final secondToday = fixture.appointment(
        id: 'approved',
        status: AppointmentStatus.approved,
        staffId: 'staff-a',
      );
      repository.emitToday([firstToday, secondToday]);
      await flush();
      expect(summary().todayAppointmentCount, 2);
      expect(summary().distinctStaffCount, 2);

      final pending = fixture.appointment(
        id: 'pending',
        status: AppointmentStatus.pending,
        createdAt: DateTime(2026, 11, 13, 21),
      );
      repository.emitPending([pending]);
      await flush();
      expect(summary().pendingCount, 1);
      expect(summary().oldestPendingCreatedAt, DateTime(2026, 11, 13, 21));
    },
  );

  test('branch selection recomputes today and pending figures', () async {
    cubit.updateCatalog(fixture.catalog);
    repository.emitToday([
      fixture.appointment(id: 'today-a', status: AppointmentStatus.approved),
      fixture.appointment(
        id: 'today-b',
        status: AppointmentStatus.noShow,
        branchId: 'branch-b',
        departmentId: 'department-b',
        staffId: 'staff-b',
      ),
    ]);
    repository.emitPending([
      fixture.appointment(id: 'pending-a', status: AppointmentStatus.pending),
      fixture.appointment(
        id: 'pending-b',
        status: AppointmentStatus.pending,
        date: DateTime(2026, 11, 15),
        branchId: 'branch-b',
        departmentId: 'department-b',
        staffId: 'staff-b',
      ),
    ]);
    await flush();

    expect(summary().todayAppointmentCount, 2);
    expect(summary().pendingCount, 2);

    cubit.selectBranch('branch-a');
    expect(summary().selectedBranchId, 'branch-a');
    expect(summary().todayAppointmentCount, 1);
    expect(summary().pendingCount, 1);

    cubit.selectBranch(null);
    expect(summary().selectedBranchId, isNull);
    expect(summary().todayAppointmentCount, 2);
    expect(summary().pendingCount, 2);
  });

  test(
    'reports stream failure and retry starts fresh watches using the clock',
    () async {
      expect(repository.watchedAdminQueries.single.$1, fixture.calendarDay);
      repository.todayEvents.addError(StateError('offline'));
      await flush();

      final failed = cubit.state;
      expect(failed, isA<AdminDashboardFailure>());
      if (failed is AdminDashboardFailure) {
        expect(failed.errorCode, AppointmentErrorCode.unavailable);
      }

      clock.instant = DateTime(2026, 11, 15, 1);
      cubit.retry();
      expect(cubit.state, isA<AdminDashboardLoading>());
      expect(repository.watchedAdminQueries, hasLength(2));
      final retryDay = CalendarDate.fromDateTime(clock.instant);
      expect(repository.watchedAdminQueries.last.$1, retryDay);
      expect(repository.watchedAdminQueries.last.$2, retryDay);

      repository.emitToday(const []);
      repository.emitPending(const []);
      cubit.updateCatalog(fixture.catalog);
      await flush();
      expect(summary().todayAppointmentCount, 0);
    },
  );
}

final class _DashboardAppointmentRepository implements AppointmentRepository {
  final StreamController<DataResult<List<Appointment>>> todayEvents =
      StreamController<DataResult<List<Appointment>>>.broadcast();
  final StreamController<DataResult<List<Appointment>>> pendingEvents =
      StreamController<DataResult<List<Appointment>>>.broadcast();
  final List<(CalendarDate, CalendarDate)> watchedAdminQueries = [];

  void emitToday(List<Appointment> appointments) {
    todayEvents.add(DataResult.success(data: appointments));
  }

  void emitPending(List<Appointment> appointments) {
    pendingEvents.add(DataResult.success(data: appointments));
  }

  Future<void> close() async {
    await Future.wait([todayEvents.close(), pendingEvents.close()]);
  }

  @override
  Future<DataResult<Appointment>> book(
    Appointment candidate,
    AppointmentBookingCheck check,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<AppointmentResult> changeStatus(
    String id,
    AppointmentStatusChange change,
  ) {
    throw UnimplementedError();
  }

  @override
  Stream<DataResult<List<Appointment>>> watchPatientAppointments(
    String patientId,
  ) {
    throw UnimplementedError();
  }

  @override
  Stream<DataResult<List<Appointment>>> watchStaffAppointments(
    String staffId,
    CalendarDate from,
    CalendarDate through,
  ) {
    throw UnimplementedError();
  }

  @override
  Stream<DataResult<List<Appointment>>> watchAdminAppointments(
    CalendarDate from,
    CalendarDate through,
  ) {
    watchedAdminQueries.add((from, through));
    return todayEvents.stream;
  }

  @override
  Stream<DataResult<List<Appointment>>> watchPendingAppointments() {
    return pendingEvents.stream;
  }

  @override
  Stream<DataResult<List<BookedSlot>>> watchStaffBookedSlots(
    String staffId,
    CalendarDate date,
  ) {
    throw UnimplementedError();
  }
}

final class _TestClock implements Clock {
  _TestClock(this.instant);

  DateTime instant;

  @override
  DateTime now() => instant;
}
