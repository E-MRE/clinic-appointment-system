import 'package:clinic_appointment_system/core/constants/entity_constants.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/errors/appointment_exception.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';

import 'support/appointment_fixture.dart';

void main() {
  const fixture = AppointmentFixture();
  group('construction, restore, equality and immutability', () {
    test('patient requests a pending appointment with a first audit entry', () {
      final appointment = fixture.request();
      expect(appointment.id, EntityConstants.unsavedId);
      expect(appointment.patientId, 'patient');
      expect(appointment.staffId, 'staff');
      expect(appointment.branchId, 'branch');
      expect(appointment.departmentId, 'department');
      expect(appointment.serviceId, 'service');
      expect(appointment.serviceName, 'Examination');
      expect(appointment.fee, fixture.fee);
      expect(appointment.date, fixture.date);
      expect(appointment.range, fixture.range);
      expect(appointment.duration, const Duration(minutes: 30));
      expect(appointment.startsAt, fixture.start);
      expect(appointment.startsAt.isUtc, isFalse);
      expect(appointment.status, AppointmentStatus.pending);
      expect(appointment.history, [fixture.change(AppointmentStatus.pending)]);
    });

    for (final status in AppointmentStatus.values) {
      test('restores stored $status without changing its audit entries', () {
        final entry = fixture.change(status);
        final appointment = fixture.restore(status, history: [entry]);
        expect(appointment.id, 'appointment');
        expect(appointment.status, status);
        expect(appointment.history, [entry]);
      });
    }

    for (final entry in <String, List<AppointmentStatusChange>>{
      'empty': [],
      'mismatching': [fixture.change(AppointmentStatus.rejected)],
    }.entries) {
      test('restore rejects ${entry.key} history', () {
        expect(
          () =>
              fixture.restore(AppointmentStatus.pending, history: entry.value),
          throwsA(
            isA<AppointmentException>().having(
              (error) => error.code,
              'code',
              AppointmentErrorCode.invalidHistory,
            ),
          ),
        );
      });
    }

    test('history is defensively copied and cannot be edited', () {
      final entries = [fixture.change(AppointmentStatus.pending)];
      final appointment = fixture.restore(
        AppointmentStatus.pending,
        history: entries,
      );
      entries.clear();
      expect(appointment.history, [fixture.change(AppointmentStatus.pending)]);
      expect(() => appointment.history.clear(), throwsUnsupportedError);
      expect(
        () =>
            appointment.history.add(fixture.change(AppointmentStatus.approved)),
        throwsUnsupportedError,
      );
      expect(() => fixture.request().history.clear(), throwsUnsupportedError);
    });

    test('appointment equality includes stored fields, status and history', () {
      final original = fixture.restore(AppointmentStatus.pending);
      final equal = fixture.restore(AppointmentStatus.pending);
      expect(original, equal);
      expect(original.hashCode, equal.hashCode);
      expect(original, isNot(fixture.restore(AppointmentStatus.approved)));
      expect(
        original,
        isNot(fixture.restore(AppointmentStatus.pending, id: 'other')),
      );
      final otherEntry = AppointmentStatusChange(
        status: AppointmentStatus.pending,
        byUserId: 'other',
        byRole: UserRole.admin,
        at: fixture.start,
      );
      expect(
        original,
        isNot(
          fixture.restore(AppointmentStatus.pending, history: [otherEntry]),
        ),
      );
    });

    test('audit entries compare all four values', () {
      final entry = fixture.change(AppointmentStatus.pending);
      expect(entry, fixture.change(AppointmentStatus.pending));
      expect(
        entry.hashCode,
        fixture.change(AppointmentStatus.pending).hashCode,
      );
      for (final different in [
        fixture.change(AppointmentStatus.approved),
        AppointmentStatusChange(
          status: entry.status,
          byUserId: 'other',
          byRole: entry.byRole,
          at: entry.at,
        ),
        AppointmentStatusChange(
          status: entry.status,
          byUserId: entry.byUserId,
          byRole: UserRole.admin,
          at: entry.at,
        ),
        AppointmentStatusChange(
          status: entry.status,
          byUserId: entry.byUserId,
          byRole: entry.byRole,
          at: fixture.start,
        ),
      ]) {
        expect(entry, isNot(different));
      }
    });
  });
}
