import 'dart:async';

import 'package:clinic_appointment_system/features/appointments/domain/actors/staff_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/results/appointment_result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/change_appointment_status_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_state.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/appointment_reject_cubit.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../../../appointments/domain/support/appointment_fixture.dart';
import '../../../appointments/presentation/doubles/staff_appointment_repository.dart';

void main() {
  const fixture = AppointmentFixture();
  final request = fixture.request().withId('request-18');
  const staff = StaffAppointmentActor.doctor(id: 'staff');
  late StaffAppointmentRepository repository;
  late AppointmentRejectCubit cubit;

  setUp(() {
    repository = StaffAppointmentRepository()..stored[request.id] = request;
    cubit = AppointmentRejectCubit(
      ChangeAppointmentStatusUseCase(
        repository,
        FixedClock(DateTime(2026, 10, 20)),
      ),
    );
  });

  tearDown(() async {
    await cubit.close();
    await repository.events.close();
  });

  test('rejects with optional reason as the assigned staff member', () async {
    await cubit.perform(request, by: staff, reason: 'Doktor o gün izinli');

    expect(repository.changedIds, [request.id]);
    final rejected = repository.stored[request.id];
    expect(rejected?.status, AppointmentStatus.rejected);
    expect(rejected?.statusReason, 'Doktor o gün izinli');
    expect(rejected?.history.last.byUserId, staff.id);
    expect(rejected?.history.last.byRole, staff.role);
    expect(rejected?.history.last.reason, 'Doktor o gün izinli');
    expect(cubit.action, AppointmentAction.reject);
    expect(cubit.state, isA<AppointmentActionSuccess>());
  });

  test('rejects without reason when none is provided', () async {
    await cubit.perform(request, by: staff);

    expect(repository.changedIds, [request.id]);
    final rejected = repository.stored[request.id];
    expect(rejected?.status, AppointmentStatus.rejected);
    expect(rejected?.statusReason, isNull);
    expect(cubit.state, isA<AppointmentActionSuccess>());
  });

  test('keeps the appointment id during a single in-flight request', () async {
    final pending = Completer<AppointmentResult>();
    repository.pendingChange = pending;
    final first = cubit.perform(request, by: staff, reason: 'Meşgul');
    await cubit.perform(request, by: staff, reason: 'Meşgul');

    expect(repository.changedIds, [request.id]);
    expect(cubit.state, isA<AppointmentActionInProgress>());
    expect(
      (cubit.state as AppointmentActionInProgress).appointmentId,
      request.id,
    );
    pending.complete(AppointmentResult.success(request));
    await first;
    expect(cubit.state, isA<AppointmentActionSuccess>());
  });

  test('reports typed lifecycle failures', () async {
    repository.changeFailure = AppointmentErrorCode.notPermitted;

    await cubit.perform(request, by: staff);

    expect(cubit.state, isA<AppointmentActionFailure>());
    expect(
      (cubit.state as AppointmentActionFailure).errorCode,
      AppointmentErrorCode.notPermitted,
    );
  });

  test('ignores a result arriving after close', () async {
    final pending = Completer<AppointmentResult>();
    repository.pendingChange = pending;
    final rejection = cubit.perform(request, by: staff);
    await cubit.close();
    pending.complete(AppointmentResult.success(request));
    await rejection;

    expect(cubit.state, isA<AppointmentActionInProgress>());
    expect(
      (cubit.state as AppointmentActionInProgress).appointmentId,
      request.id,
    );
    await cubit.perform(request, by: staff);
    expect(repository.changedIds, [request.id]);
  });
}
