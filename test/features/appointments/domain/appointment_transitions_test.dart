import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status_state.dart';
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

  group('state capabilities', () {
    for (final status in AppointmentStatus.values) {
      test('${status.name} exposes exactly its allowed capabilities', () {
        final state = status.state;
        final capabilities = {
          'approve': state.approvable,
          'reject': state.rejectable,
          'cancelByPatient': state.patientCancellable,
          'cancelByStaff': state.staffCancellable,
          'complete': state.completable,
          'markNoShow': state.noShowMarkable,
        };
        for (final capability in capabilities.entries) {
          if (allowed[status]?.containsKey(capability.key) ?? false) {
            expect(capability.value, same(state));
          } else {
            expect(capability.value, isNull);
          }
        }
      });
    }
  });

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
            final updated = fixture.success(
              fixture.transition(transition.key, original, by, at),
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
        final approved = fixture.success(
          requested.approve(by: staff, at: fixture.beforeStart),
        );
        final completed = fixture.success(
          approved.complete(by: staff, at: fixture.start),
        );
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

  group('status change reasons and statusReason projection', () {
    final staff = fixture.actor(UserRole.doctor, 'staff');

    for (final (label, create) in [
      (
        'reject',
        (Appointment a, String? reason) =>
            a.reject(by: staff, at: fixture.beforeStart, reason: reason),
      ),
      (
        'cancelByStaff',
        (Appointment a, String? reason) =>
            a.cancelByStaff(by: staff, at: fixture.start, reason: reason),
      ),
    ]) {
      final baseStatus = label == 'reject'
          ? AppointmentStatus.pending
          : AppointmentStatus.approved;

      test('$label stores trimmed reason and sets statusReason', () {
        final appointment = fixture.restore(baseStatus);
        final result = create(appointment, '   Device maintenance required   ');
        final updated = fixture.success(result);
        expect(updated.statusReason, 'Device maintenance required');
        expect(updated.history.last.reason, 'Device maintenance required');
      });

      test('$label turns blank reason into null', () {
        final appointment = fixture.restore(baseStatus);
        final result = create(appointment, '     ');
        final updated = fixture.success(result);
        expect(updated.statusReason, isNull);
        expect(updated.history.last.reason, isNull);
      });

      test('$label allows exactly 500 characters', () {
        final appointment = fixture.restore(baseStatus);
        final reason500 = 'a' * 500;
        final result = create(appointment, reason500);
        final updated = fixture.success(result);
        expect(updated.statusReason, reason500);
      });

      test('$label rejects 501 characters with reasonTooLong', () {
        final appointment = fixture.restore(baseStatus);
        final reason501 = 'a' * 501;
        final result = create(appointment, reason501);
        fixture.expectError(result, AppointmentErrorCode.reasonTooLong);
        expect(appointment.status, baseStatus);
        expect(appointment.history, [fixture.change(baseStatus)]);
      });
    }

    test('approve, complete, markNoShow, cancelByPatient have no reason', () {
      final requested = fixture.request();
      expect(requested.history.single.reason, isNull);
      expect(requested.statusReason, isNull);

      final approved = fixture.success(
        requested.approve(by: staff, at: fixture.beforeStart),
      );
      expect(approved.history.last.reason, isNull);
      expect(approved.statusReason, isNull);

      final completed = fixture.success(
        approved.complete(by: staff, at: fixture.start),
      );
      expect(completed.history.last.reason, isNull);
      expect(completed.statusReason, isNull);

      final app2 = fixture.restore(AppointmentStatus.approved);
      final noShow = fixture.success(
        app2.markNoShow(by: staff, at: fixture.atTolerance),
      );
      expect(noShow.history.last.reason, isNull);
      expect(noShow.statusReason, isNull);

      final app3 = fixture.restore(AppointmentStatus.approved);
      final patient = fixture.actor(UserRole.patient, 'patient');
      final cancelled = fixture.success(
        app3.cancelByPatient(by: patient, at: fixture.beforeStart),
      );
      expect(cancelled.history.last.reason, isNull);
      expect(cancelled.statusReason, isNull);
    });
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
              fixture.expectError(
                fixture.transition(method, original, by, fixture.atTolerance),
                AppointmentErrorCode.invalidTransition,
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
