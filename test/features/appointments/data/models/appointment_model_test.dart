import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/data/models/appointment_model.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final date = CalendarDate(year: 2026, month: 10, day: 20);
  final range = TimeRange(
    start: ClockTime(hour: 10, minute: 0),
    end: ClockTime(hour: 10, minute: 30),
  );
  final at = DateTime(2026, 10, 15, 12, 0);

  Appointment createAppointment({String patientName = 'Elif Kaya'}) {
    return Appointment.restore(
      id: 'apt-1',
      patientId: 'patient-1',
      patientName: patientName,
      staffId: 'staff-1',
      branchId: 'branch-1',
      departmentId: 'dept-1',
      serviceId: 'srv-1',
      serviceName: 'Kardiyoloji Muayenesi',
      fee: Money.minorUnits(120000),
      date: date,
      range: range,
      status: AppointmentStatus.pending,
      history: [
        AppointmentStatusChange(
          status: AppointmentStatus.pending,
          byUserId: 'patient-1',
          byRole: UserRole.patient,
          at: at,
        ),
      ],
    );
  }

  group('AppointmentModel', () {
    test('toJson writes patientName', () {
      final appointment = createAppointment(patientName: 'Elif Kaya');
      final model = AppointmentModel.fromEntity(appointment);
      final json = model.toJson();
      expect(json[FirestoreConstants.patientName], 'Elif Kaya');
      expect(json[FirestoreConstants.patientId], 'patient-1');
    });

    test('fromJson reads patientName', () {
      final json = {
        FirestoreConstants.patientId: 'patient-1',
        FirestoreConstants.patientName: 'Elif Kaya',
        FirestoreConstants.staffId: 'staff-1',
        FirestoreConstants.branchId: 'branch-1',
        FirestoreConstants.departmentId: 'dept-1',
        FirestoreConstants.serviceId: 'srv-1',
        FirestoreConstants.serviceName: 'Kardiyoloji Muayenesi',
        FirestoreConstants.feeMinorUnits: 120000,
        FirestoreConstants.date: '2026-10-20',
        FirestoreConstants.start: '10:00',
        FirestoreConstants.end: '10:30',
        FirestoreConstants.status: 'pending',
        FirestoreConstants.history: [
          {
            FirestoreConstants.status: 'pending',
            FirestoreConstants.byUserId: 'patient-1',
            FirestoreConstants.byRole: 'patient',
            FirestoreConstants.at: Timestamp.fromDate(at),
          },
        ],
      };
      final model = AppointmentModel.fromJson('apt-1', json);
      expect(model.appointment.patientName, 'Elif Kaya');
    });

    test('fromJson decodes missing patientName to an empty string', () {
      final json = {
        FirestoreConstants.patientId: 'patient-1',
        FirestoreConstants.staffId: 'staff-1',
        FirestoreConstants.branchId: 'branch-1',
        FirestoreConstants.departmentId: 'dept-1',
        FirestoreConstants.serviceId: 'srv-1',
        FirestoreConstants.serviceName: 'Kardiyoloji Muayenesi',
        FirestoreConstants.feeMinorUnits: 120000,
        FirestoreConstants.date: '2026-10-20',
        FirestoreConstants.start: '10:00',
        FirestoreConstants.end: '10:30',
        FirestoreConstants.status: 'pending',
        FirestoreConstants.history: [
          {
            FirestoreConstants.status: 'pending',
            FirestoreConstants.byUserId: 'patient-1',
            FirestoreConstants.byRole: 'patient',
            FirestoreConstants.at: Timestamp.fromDate(at),
          },
        ],
      };
      final model = AppointmentModel.fromJson('apt-1', json);
      expect(model.appointment.patientName, isEmpty);
    });

    test('round-trips patientName', () {
      final original = createAppointment(patientName: 'Ahmet Yılmaz');
      final model = AppointmentModel.fromEntity(original);
      final json = model.toJson();
      // Emulate Firestore storing the serialized payload
      final decodedModel = AppointmentModel.fromJson('apt-1', json);
      expect(decodedModel.appointment.patientName, 'Ahmet Yılmaz');
      expect(decodedModel.appointment.patientId, original.patientId);
      expect(decodedModel.appointment.serviceName, original.serviceName);
    });
  });
}
