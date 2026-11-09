import 'dart:async';

import 'package:clinic_appointment_system/features/appointments/domain/actors/patient_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/results/appointment_result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/change_appointment_status_use_case.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_state.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_appointment_cancel_cubit.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/time/support/fixed_clock.dart';
import '../doubles/patient_appointment_repository.dart';
import '../doubles/patient_fixtures.dart';

void main() {
  const fixtures = PatientFixtures();
  final patient = PatientAppointmentActor(id: fixtures.patient.id);
  late PatientAppointmentRepository repository;
  late PatientAppointmentCancelCubit cubit;

  setUp(() {
    repository = PatientAppointmentRepository()
      ..stored['a1'] = fixtures.cardiology;
    cubit = PatientAppointmentCancelCubit(
      ChangeAppointmentStatusUseCase(repository, FixedClock(fixtures.now)),
    );
  });

  tearDown(() async {
    await cubit.close();
    await repository.events.close();
  });

  test('cancels through the domain as the patient', () async {
    final states = <AppointmentActionState>[];
    final subscription = cubit.stream.listen(states.add);
    await cubit.perform(fixtures.cardiology, by: patient);
    await Future<void>.delayed(Duration.zero);
    await subscription.cancel();
    expect(states, [
      isA<AppointmentActionInProgress>(),
      isA<AppointmentActionSuccess>(),
    ]);
    expect(repository.changedIds, ['a1']);
    final cancelled = repository.changeResults.single.appointment;
    expect(cancelled?.status, AppointmentStatus.cancelledByPatient);
    expect(cancelled?.history.last.byUserId, fixtures.patient.id);
    expect(cancelled?.history.last.byRole, UserRole.patient);
    expect(cancelled?.history.last.at, fixtures.now);
  });

  test('a domain refusal reports its error code', () async {
    repository.stored['a4'] = fixtures.internal;
    await cubit.perform(fixtures.internal, by: patient);
    final state = cubit.state;
    expect(state, isA<AppointmentActionFailure>());
    expect(
      (state as AppointmentActionFailure).errorCode,
      AppointmentErrorCode.invalidTransition,
    );

    repository.failure = AppointmentErrorCode.notFound;
    await cubit.perform(fixtures.cardiology, by: patient);
    expect(
      (cubit.state as AppointmentActionFailure).errorCode,
      AppointmentErrorCode.notFound,
    );
  });

  test('a thrown exception reports unavailable', () async {
    repository.exception = Exception('offline');
    await cubit.perform(fixtures.cardiology, by: patient);
    expect(
      (cubit.state as AppointmentActionFailure).errorCode,
      AppointmentErrorCode.unavailable,
    );
  });

  test('ignores a second request while one is in flight', () async {
    final pending = Completer<AppointmentResult>();
    repository.pending = pending;
    final first = cubit.perform(fixtures.cardiology, by: patient);
    await cubit.perform(fixtures.cardiology, by: patient);
    expect(repository.changedIds, ['a1']);
    expect(cubit.state, isA<AppointmentActionInProgress>());
    pending.complete(AppointmentResult.success(fixtures.cardiology));
    await first;
    expect(cubit.state, isA<AppointmentActionSuccess>());
  });

  test('a result arriving after close is ignored', () async {
    final pending = Completer<AppointmentResult>();
    repository.pending = pending;
    final request = cubit.perform(fixtures.cardiology, by: patient);
    await cubit.close();
    pending.complete(
      const AppointmentResult.error(AppointmentErrorCode.unavailable),
    );
    await request;
    expect(cubit.state, isA<AppointmentActionInProgress>());
    await cubit.perform(fixtures.cardiology, by: patient);
    expect(repository.changedIds, ['a1']);
  });
}
