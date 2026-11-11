import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/features/appointments/data/converters/appointment_history_converter.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const converter = AppointmentHistoryConverter();
  final timestamp = DateTime(2026, 10, 20, 10, 30);

  group('AppointmentHistoryConverter', () {
    test('toJson omits reason when null', () {
      final entries = [
        AppointmentStatusChange(
          status: AppointmentStatus.pending,
          byUserId: 'u1',
          byRole: UserRole.patient,
          at: timestamp,
        ),
      ];
      final json = converter.toJson(entries);
      expect(json, hasLength(1));
      expect(json.first.containsKey(FirestoreConstants.reason), isFalse);
      expect(json.first[FirestoreConstants.status], 'pending');
      expect(json.first[FirestoreConstants.byUserId], 'u1');
      expect(json.first[FirestoreConstants.byRole], 'patient');
      expect(json.first[FirestoreConstants.at], Timestamp.fromDate(timestamp));
    });

    test('toJson writes reason when non-null', () {
      final entries = [
        AppointmentStatusChange(
          status: AppointmentStatus.rejected,
          byUserId: 'u2',
          byRole: UserRole.doctor,
          at: timestamp,
          reason: 'Cihaz bakımda',
        ),
      ];
      final json = converter.toJson(entries);
      expect(json, hasLength(1));
      expect(json.first[FirestoreConstants.reason], 'Cihaz bakımda');
    });

    test('fromJson decodes entries with and without reason', () {
      final json = [
        {
          FirestoreConstants.status: 'pending',
          FirestoreConstants.byUserId: 'u1',
          FirestoreConstants.byRole: 'patient',
          FirestoreConstants.at: Timestamp.fromDate(timestamp),
        },
        {
          FirestoreConstants.status: 'rejected',
          FirestoreConstants.byUserId: 'u2',
          FirestoreConstants.byRole: 'doctor',
          FirestoreConstants.at: Timestamp.fromDate(timestamp),
          FirestoreConstants.reason: 'Cihaz bakımda',
        },
      ];
      final entries = converter.fromJson(json);
      expect(entries, hasLength(2));
      expect(entries[0].status, AppointmentStatus.pending);
      expect(entries[0].reason, isNull);
      expect(entries[1].status, AppointmentStatus.rejected);
      expect(entries[1].reason, 'Cihaz bakımda');
    });

    test('round-trips entries preserving reasons', () {
      final original = [
        AppointmentStatusChange(
          status: AppointmentStatus.pending,
          byUserId: 'u1',
          byRole: UserRole.patient,
          at: timestamp,
        ),
        AppointmentStatusChange(
          status: AppointmentStatus.cancelledByStaff,
          byUserId: 'u2',
          byRole: UserRole.doctor,
          at: timestamp.add(const Duration(minutes: 10)),
          reason: 'Acil ameliyat',
        ),
      ];
      final json = converter.toJson(original);
      final decoded = converter.fromJson(json);
      expect(decoded, original);
    });
  });
}
