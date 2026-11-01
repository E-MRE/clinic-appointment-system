import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/errors/appointment_exception.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/appointment_fixture.dart';

void main() {
  const fixture = AppointmentFixture();
  // The acceptance table is the independent source of expected transitions.
  const allowed = {
    AppointmentStatus.pending: {
      'approve': AppointmentStatus.approved,
      'reject': AppointmentStatus.rejected,
      'cancelByPatient': AppointmentStatus.cancelledByPatient,
    },
    AppointmentStatus.approved: {
      'cancelByPatient': AppointmentStatus.cancelledByPatient,
      'cancelByStaff': AppointmentStatus.cancelledByStaff,
      'complete': AppointmentStatus.completed,
      'markNoShow': AppointmentStatus.noShow,
    },
  };
  const methods = [
    'approve',
    'reject',
    'cancelByPatient',
    'cancelByStaff',
    'complete',
    'markNoShow',
  ];

  group('allowed transitions and audit trail', () {
    for (final from in allowed.entries) {
      for (final transition in from.value.entries) {
        final List<UserRole> roles;
        if (transition.key == 'cancelByPatient') {
          roles = [UserRole.patient];
        } else if (transition.key == 'markNoShow') {
          roles = [UserRole.doctor, UserRole.technician];
        } else {
          roles = [UserRole.doctor, UserRole.technician, UserRole.admin];
        }
        for (final role in roles) {
          test('${from.key.name}.${transition.key} by ${role.name}', () {
            String actorId = 'staff';
            DateTime at = fixture.atTolerance;
            if (role == UserRole.patient) {
              actorId = 'patient';
              at = fixture.beforeStart;
            } else if (role == UserRole.admin) {
              actorId = 'admin';
            }
            final by = fixture.actor(role, actorId);
            final original = fixture.restore(from.key);
            final updated = fixture.transition(
              transition.key,
              original,
              by,
              at,
            );
            expect(updated.status, transition.value);
            expect(updated.history, [
              ...original.history,
              AppointmentStatusChange(
                status: transition.value,
                byUserId: actorId,
                byRole: role,
                at: at,
              ),
            ]);
            expect(identical(updated, original), isFalse);
            expect(original.status, from.key);
            expect(original.history, [fixture.change(from.key)]);
            expect(() => updated.history.clear(), throwsUnsupportedError);
            final expected = fixture.restore(
              transition.value,
              history: updated.history,
            );
            expect(
              updated,
              expected,
              reason: 'All booked fields are preserved',
            );
          });
        }
      }
    }

    test(
      'request, approve and complete retain the entire ordered audit trail',
      () {
        final staff = fixture.actor(UserRole.doctor, 'staff');
        final requested = fixture.request();
        final approved = requested.approve(by: staff, at: fixture.beforeStart);
        final completed = approved.complete(by: staff, at: fixture.start);
        expect(completed.history, [
          fixture.change(AppointmentStatus.pending),
          AppointmentStatusChange(
            status: AppointmentStatus.approved,
            byUserId: 'staff',
            byRole: UserRole.doctor,
            at: fixture.beforeStart,
          ),
          AppointmentStatusChange(
            status: AppointmentStatus.completed,
            byUserId: 'staff',
            byRole: UserRole.doctor,
            at: fixture.start,
          ),
        ]);
        expect(requested.history, hasLength(1));
        expect(approved.history, hasLength(2));
      },
    );
  });

  group('forbidden transition matrix', () {
    for (final status in AppointmentStatus.values) {
      for (final method in methods) {
        if (allowed[status]?.containsKey(method) ?? false) {
          continue;
        }
        for (final role in UserRole.values) {
          test(
            '${status.name}.$method by ${role.name} is invalidTransition',
            () {
              final original = fixture.restore(status);
              final by = fixture.actor(role, 'staff');
              expect(
                () => fixture.transition(
                  method,
                  original,
                  by,
                  fixture.atTolerance,
                ),
                throwsA(
                  isA<AppointmentException>().having(
                    (error) => error.code,
                    'code',
                    AppointmentErrorCode.invalidTransition,
                  ),
                ),
              );
              expect(original.history, [fixture.change(status)]);
              expect(original.status, status);
            },
          );
        }
      }
    }
  });
}
