import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/errors/appointment_exception.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/appointment_fixture.dart';

void main() {
  const fixture = AppointmentFixture();
  group('time boundaries', () {
    for (final status in [
      AppointmentStatus.pending,
      AppointmentStatus.approved,
    ]) {
      test(
        '${status.name}: patient cancellation one minute before start succeeds',
        () {
          final updated = fixture
              .restore(status)
              .cancelByPatient(by: fixture.patient, at: fixture.beforeStart);
          expect(updated.status, AppointmentStatus.cancelledByPatient);
          expect(updated.history.last.at, fixture.beforeStart);
        },
      );
      for (final at in [fixture.start, fixture.atTolerance]) {
        test('${status.name}: patient cancellation at $at is tooLate', () {
          final original = fixture.restore(status);
          expect(
            () => original.cancelByPatient(by: fixture.patient, at: at),
            throwsA(
              isA<AppointmentException>().having(
                (error) => error.code,
                'code',
                AppointmentErrorCode.tooLate,
              ),
            ),
          );
          expect(original.history, [fixture.change(status)]);
        });
      }
    }

    for (final role in [UserRole.doctor, UserRole.technician, UserRole.admin]) {
      final actor = fixture.actor(role, 'staff');
      test('${role.name}: complete one minute before start is tooEarly', () {
        final original = fixture.restore(AppointmentStatus.approved);
        expect(
          () => original.complete(by: actor, at: fixture.beforeStart),
          throwsA(
            isA<AppointmentException>().having(
              (error) => error.code,
              'code',
              AppointmentErrorCode.tooEarly,
            ),
          ),
        );
        expect(original.status, AppointmentStatus.approved);
        expect(original.history, [fixture.change(AppointmentStatus.approved)]);
      });
      test('${role.name}: complete exactly at start succeeds', () {
        final updated = fixture
            .restore(AppointmentStatus.approved)
            .complete(by: actor, at: fixture.start);
        expect(updated.status, AppointmentStatus.completed);
        expect(updated.history.last.at, fixture.start);
      });
    }

    for (final role in [UserRole.doctor, UserRole.technician]) {
      final actor = fixture.actor(role, 'staff');
      for (final at in [fixture.start, fixture.beforeTolerance]) {
        test('${role.name}: markNoShow at $at is tooEarly', () {
          final original = fixture.restore(AppointmentStatus.approved);
          expect(
            () => original.markNoShow(by: actor, at: at),
            throwsA(
              isA<AppointmentException>().having(
                (error) => error.code,
                'code',
                AppointmentErrorCode.tooEarly,
              ),
            ),
          );
          expect(original.history, [
            fixture.change(AppointmentStatus.approved),
          ]);
        });
      }
      test(
        '${role.name}: markNoShow exactly 15 minutes after start succeeds',
        () {
          final updated = fixture
              .restore(AppointmentStatus.approved)
              .markNoShow(by: actor, at: fixture.atTolerance);
          expect(updated.status, AppointmentStatus.noShow);
          expect(updated.history.last.at, fixture.atTolerance);
        },
      );
    }
  });
}
