import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/errors/appointment_exception.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/appointment_fixture.dart';

void main() {
  const fixture = AppointmentFixture();
  final notPermitted = throwsA(
    isA<AppointmentException>().having(
      (error) => error.code,
      'code',
      AppointmentErrorCode.notPermitted,
    ),
  );
  group('actor permissions', () {
    for (final role in UserRole.values) {
      if (role == UserRole.patient) {
        continue;
      }
      test('${role.name} cannot request even with the patient identifier', () {
        expect(
          () => fixture.request(by: fixture.actor(role, 'patient')),
          notPermitted,
        );
      });
    }
    test('another patient cannot request for the appointment patient', () {
      expect(
        () => fixture.request(by: fixture.actor(UserRole.patient, 'other')),
        notPermitted,
      );
    });

    final staffActions = [
      (AppointmentStatus.pending, 'approve'),
      (AppointmentStatus.pending, 'reject'),
      (AppointmentStatus.approved, 'cancelByStaff'),
      (AppointmentStatus.approved, 'complete'),
      (AppointmentStatus.approved, 'markNoShow'),
    ];
    final deniedStaffActors = [
      fixture.actor(UserRole.doctor, 'other'),
      fixture.actor(UserRole.technician, 'other'),
      fixture.patient,
      fixture.actor(UserRole.patient, 'staff'),
    ];
    for (final (status, method) in staffActions) {
      for (final actor in deniedStaffActors) {
        test(
          '${status.name}.$method denies ${actor.role.name}/${actor.id}',
          () {
            final original = fixture.restore(status);
            expect(
              () => fixture.transition(
                method,
                original,
                actor,
                fixture.atTolerance,
              ),
              notPermitted,
            );
            expect(original.status, status);
            expect(original.history, [fixture.change(status)]);
          },
        );
      }
    }

    for (final status in [
      AppointmentStatus.pending,
      AppointmentStatus.approved,
    ]) {
      for (final actor in [
        fixture.actor(UserRole.patient, 'other'),
        fixture.actor(UserRole.doctor, 'patient'),
        fixture.actor(UserRole.technician, 'patient'),
        fixture.actor(UserRole.admin, 'patient'),
      ]) {
        test(
          '${status.name}.cancelByPatient denies ${actor.role.name}/${actor.id}',
          () {
            expect(
              () => fixture
                  .restore(status)
                  .cancelByPatient(by: actor, at: fixture.beforeStart),
              notPermitted,
            );
          },
        );
      }
    }

    for (final id in ['admin', 'staff']) {
      test('admin $id cannot mark no-show even at the tolerance boundary', () {
        expect(
          () => fixture
              .restore(AppointmentStatus.approved)
              .markNoShow(
                by: fixture.actor(UserRole.admin, id),
                at: fixture.atTolerance,
              ),
          notPermitted,
        );
      });
    }
  });
}
