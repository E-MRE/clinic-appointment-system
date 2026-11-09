import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/usecases/watch_patient_appointments_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_appointments_cubit.dart';
import 'package:clinic_appointment_system/features/patient/presentation/cubit/patient_appointments_state.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/patient_appointment_repository.dart';
import '../doubles/patient_fixtures.dart';

void main() {
  const fixtures = PatientFixtures();
  late PatientAppointmentRepository repository;
  late PatientAppointmentsCubit cubit;

  Future<void> flush() => Future<void>.delayed(Duration.zero);

  setUp(() {
    repository = PatientAppointmentRepository();
    cubit = PatientAppointmentsCubit(
      WatchPatientAppointmentsUseCase(repository),
    );
  });

  tearDown(() async {
    await cubit.close();
    await repository.events.close();
  });

  test('watches only the patient and emits each new list', () async {
    cubit.watch('elif');
    expect(cubit.state, isA<PatientAppointmentsLoading>());
    expect(repository.watchedPatients, ['elif']);

    repository.emit([fixtures.lipid]);
    await flush();
    final first = cubit.state;
    expect(first, isA<PatientAppointmentsLoaded>());
    expect(
      (first as PatientAppointmentsLoaded).appointments.single.status,
      AppointmentStatus.pending,
    );

    final approved = fixtures.appointment(
      'a2',
      'lipid',
      'zeynep',
      AppointmentStatus.approved,
      DateTime(2026, 10, 28, 8, 30),
      10,
    );
    repository.emit([approved]);
    await flush();
    final second = cubit.state as PatientAppointmentsLoaded;
    expect(second.appointments.single.status, AppointmentStatus.approved);
  });

  test('a failed result keeps its appointment error code', () async {
    cubit.watch('elif');
    repository.events.add(
      const DataResult.error(errorCode: AppointmentErrorCode.invalidRecord),
    );
    await flush();
    final state = cubit.state;
    expect(state, isA<PatientAppointmentsFailure>());
    expect(
      (state as PatientAppointmentsFailure).errorCode,
      AppointmentErrorCode.invalidRecord,
    );
  });

  test('foreign codes and stream errors become unavailable', () async {
    cubit.watch('elif');
    repository.events.add(
      const DataResult.error(errorCode: InstitutionErrorCode.unavailable),
    );
    await flush();
    expect(
      (cubit.state as PatientAppointmentsFailure).errorCode,
      AppointmentErrorCode.unavailable,
    );

    cubit.retry();
    expect(cubit.state, isA<PatientAppointmentsLoading>());
    repository.events.addError(Exception('offline'));
    await flush();
    expect(
      (cubit.state as PatientAppointmentsFailure).errorCode,
      AppointmentErrorCode.unavailable,
    );
    expect(repository.watchedPatients, ['elif', 'elif']);
  });

  test('close cancels the subscription and ignores later events', () async {
    cubit.watch('elif');
    await cubit.close();
    expect(repository.events.hasListener, isFalse);
    cubit.watch('elif');
    expect(repository.watchedPatients, ['elif']);
  });
}
