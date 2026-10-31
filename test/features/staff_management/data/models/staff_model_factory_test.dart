import 'package:clinic_appointment_system/features/staff_management/data/models/staff_model_factory.dart';
import 'package:clinic_appointment_system/features/users/data/models/doctor_model.dart';
import 'package:clinic_appointment_system/features/users/data/models/technician_model.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../domain/doubles/staff_fixtures.dart';

void main() {
  const StaffModelFactory factory = StaffModelFactory();
  const StaffFixtures fixtures = StaffFixtures();

  test('round-trips doctor fields without storing the document id', () {
    final Doctor doctor = fixtures.doctor(id: 'doctor', serviceIds: ['exam']);
    final Map<String, dynamic> json = DoctorModel.fromEntity(doctor).toJson();
    expect(json, {
      'role': 'doctor',
      'fullName': 'Ada Kaya',
      'email': 'ada@example.com',
      'branchId': 'branch',
      'departmentId': 'department',
      'specialty': 'Cardiology',
      'serviceIds': ['exam'],
    });
    final Staff restored = factory.fromJson({...json, 'id': 'doctor'});
    expect(restored.id, 'doctor');
    expect(
      restored,
      isA<Doctor>().having(
        (Doctor value) => value.specialty,
        'specialty',
        'Cardiology',
      ),
    );
    expect(restored.serviceIds, ['exam']);
  });
  test('round-trips technician without doctor-only fields', () {
    final Technician technician = fixtures.technician(
      id: 'tech',
      serviceIds: ['lab'],
    );
    final Map<String, dynamic> json = TechnicianModel.fromEntity(
      technician,
    ).toJson();
    expect(json, {
      'role': 'technician',
      'fullName': 'Ece Kaya',
      'email': 'ece@example.com',
      'branchId': 'branch',
      'departmentId': 'department',
      'serviceIds': ['lab'],
    });
    final Staff restored = factory.fromJson({...json, 'id': 'tech'});
    expect(restored, isA<Technician>());
    expect(restored.id, 'tech');
    expect(restored.serviceIds, ['lab']);
  });

  test('rejects non-staff, unknown, missing and mistyped roles', () {
    for (final String role in ['patient', 'admin', 'unknown', 'Doctor']) {
      expect(() => factory.fromJson({'role': role}), throwsArgumentError);
    }
    for (final Map<String, dynamic> json in [
      {},
      {'role': null},
      {'role': 42},
    ]) {
      expect(() => factory.fromJson(json), throwsA(isA<TypeError>()));
    }
  });

  test('legacy staff documents default missing assignment fields', () {
    const Map<String, dynamic> json = {
      'id': 'legacy',
      'fullName': 'Ada',
      'email': 'ada@example.com',
      'branchId': 'b',
      'departmentId': 'd',
    };
    final Staff doctor = factory.fromJson({...json, 'role': 'doctor'});
    final Staff technician = factory.fromJson({...json, 'role': 'technician'});
    expect(doctor.serviceIds, isEmpty);
    expect(
      doctor,
      isA<Doctor>().having((Doctor value) => value.specialty, 'specialty', ''),
    );
    expect(technician.serviceIds, isEmpty);
  });

  test('rejects missing required and malformed assignment fields', () {
    for (final String role in ['doctor', 'technician']) {
      for (final Map<String, dynamic> fields in [
        <String, dynamic>{},
        {
          'fullName': 'Ada',
          'email': 'a@example.com',
          'branchId': 'b',
          'departmentId': 'd',
          'serviceIds': [42],
        },
      ]) {
        expect(
          () => factory.fromJson({'id': 'bad', 'role': role, ...fields}),
          throwsA(isA<CheckedFromJsonException>()),
        );
      }
    }
  });
}
