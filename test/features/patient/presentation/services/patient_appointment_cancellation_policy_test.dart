import 'package:clinic_appointment_system/features/appointments/domain/actors/patient_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/patient/presentation/services/patient_appointment_cancellation_policy.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/patient_fixtures.dart';

void main() {
  const fixtures = PatientFixtures();
  const policy = PatientAppointmentCancellationPolicy();
  final patient = PatientAppointmentActor(id: fixtures.patient.id);

  test(
    'returns the domain outcome for cancellation eligibility and reason',
    () {
      final cancellable = policy.evaluate(
        appointment: fixtures.cardiology,
        patient: patient,
        at: fixtures.now,
      );
      expect(cancellable.isSuccess, isTrue);
      expect(cancellable.errorCode, isNull);

      final tooLate = policy.evaluate(
        appointment: fixtures.cardiology,
        patient: patient,
        at: fixtures.cardiology.startsAt,
      );
      expect(tooLate.isSuccess, isFalse);
      expect(tooLate.errorCode, AppointmentErrorCode.tooLate);

      final notPermitted = policy.evaluate(
        appointment: fixtures.cardiology,
        patient: const PatientAppointmentActor(id: 'another-patient'),
        at: fixtures.now,
      );
      expect(notPermitted.isSuccess, isFalse);
      expect(notPermitted.errorCode, AppointmentErrorCode.notPermitted);
    },
  );
}
