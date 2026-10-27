import 'package:clinic_appointment_system/features/users/data/models/admin_model.dart';
import 'package:clinic_appointment_system/features/users/data/models/doctor_model.dart';
import 'package:clinic_appointment_system/features/users/data/models/patient_model.dart';
import 'package:clinic_appointment_system/features/users/data/models/technician_model.dart';
import 'package:clinic_appointment_system/features/users/data/models/user_model.dart';
import 'package:clinic_appointment_system/features/users/data/models/user_model_factory.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:json_annotation/json_annotation.dart';

void main() {
  const factory = UserModelFactory();
  const staffFields = {'branchId': 'b', 'departmentId': 'd'};
  final profiles = <(UserModel, Map<String, dynamic>)>[
    (
      const PatientModel(id: 'uid', fullName: 'Elif', email: 'e@x.com'),
      {'role': 'patient', 'fullName': 'Elif', 'email': 'e@x.com'},
    ),
    (
      const AdminModel(id: 'uid', fullName: 'Elif', email: 'e@x.com'),
      {'role': 'admin', 'fullName': 'Elif', 'email': 'e@x.com'},
    ),
    (
      const DoctorModel(
        id: 'uid',
        fullName: 'Elif',
        email: 'e@x.com',
        branchId: 'b',
        departmentId: 'd',
      ),
      {
        'role': 'doctor',
        'fullName': 'Elif',
        'email': 'e@x.com',
        ...staffFields,
      },
    ),
    (
      const TechnicianModel(
        id: 'uid',
        fullName: 'Elif',
        email: 'e@x.com',
        branchId: 'b',
        departmentId: 'd',
      ),
      {
        'role': 'technician',
        'fullName': 'Elif',
        'email': 'e@x.com',
        ...staffFields,
      },
    ),
  ];

  for (final (model, json) in profiles) {
    test('${model.role.name} model writes its role but not its id', () {
      expect(model.toJson(), json);
    });

    test('${model.role.name} document builds the matching model', () {
      final decoded = factory.fromJson({...json, 'id': 'uid'});
      expect(decoded.runtimeType, model.runtimeType);
      expect(decoded.id, 'uid');
      expect(decoded.fullName, 'Elif');
      expect(decoded.email, 'e@x.com');
      if (decoded case Staff(:final branchId, :final departmentId)) {
        expect(branchId, 'b');
        expect(departmentId, 'd');
      }
    });
  }

  test('patient model stores a patient entity', () {
    const patient = Patient(id: 'uid', fullName: 'Elif', email: 'e@x.com');
    expect(PatientModel.fromEntity(patient).toJson(), {
      'role': 'patient',
      'fullName': 'Elif',
      'email': 'e@x.com',
    });
  });

  test('unknown and missing roles fail', () {
    expect(() => factory.fromJson({'role': 'unknown'}), throwsArgumentError);
    expect(() => factory.fromJson({'role': 'Doctor'}), throwsArgumentError);
    expect(() => factory.fromJson({}), throwsA(isA<TypeError>()));
  });

  test('missing required profile fields fail', () {
    expect(
      () => factory.fromJson({'role': 'patient', 'id': 'uid', 'email': 'e'}),
      throwsA(isA<CheckedFromJsonException>()),
    );
    for (final role in ['doctor', 'technician']) {
      for (final field in staffFields.keys) {
        final json = {
          'role': role,
          'id': 'uid',
          'fullName': 'Elif',
          'email': 'e',
          ...staffFields,
        }..remove(field);
        expect(
          () => factory.fromJson(json),
          throwsA(isA<CheckedFromJsonException>()),
        );
      }
    }
  });
}
