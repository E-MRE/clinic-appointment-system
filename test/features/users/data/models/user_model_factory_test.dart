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
        serviceIds: [],
        specialty: 'Cardiology',
      ),
      {
        'role': 'doctor',
        'specialty': 'Cardiology',
        'fullName': 'Elif',
        'email': 'e@x.com',
        'serviceIds': <String>[],
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
        serviceIds: [],
      ),
      {
        'role': 'technician',
        'fullName': 'Elif',
        'email': 'e@x.com',
        'serviceIds': <String>[],
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

  test('legacy staff documents default missing and null assignment fields', () {
    for (final Map<String, dynamic> extras in [
      <String, dynamic>{},
      <String, dynamic>{'serviceIds': null, 'specialty': null},
    ]) {
      final Map<String, dynamic> json = {
        'id': 'uid',
        'fullName': 'Ada',
        'email': 'a@example.com',
        ...staffFields,
        ...extras,
      };
      final DoctorModel doctor = DoctorModel.fromJson(json);
      final TechnicianModel technician = TechnicianModel.fromJson(json);
      expect(doctor.serviceIds, isEmpty);
      expect(doctor.specialty, '');
      expect(technician.serviceIds, isEmpty);
    }
  });

  test('staff model fields survive serialization and deserialization', () {
    final Map<String, dynamic> json = {
      'id': 'uid',
      'fullName': 'Ada',
      'email': 'a@example.com',
      ...staffFields,
      'serviceIds': ['service-1', 'service-2'],
      'specialty': 'Cardiology',
    };
    final DoctorModel doctor = DoctorModel.fromJson(json);
    final TechnicianModel technician = TechnicianModel.fromJson(json);
    expect(doctor.serviceIds, ['service-1', 'service-2']);
    expect(doctor.specialty, 'Cardiology');
    expect(technician.serviceIds, ['service-1', 'service-2']);
    expect(
      DoctorModel.fromJson({...doctor.toJson(), 'id': 'uid'}).serviceIds,
      doctor.serviceIds,
    );
    expect(
      DoctorModel.fromJson({...doctor.toJson(), 'id': 'uid'}).specialty,
      doctor.specialty,
    );
    expect(
      TechnicianModel.fromJson({
        ...technician.toJson(),
        'id': 'uid',
      }).serviceIds,
      technician.serviceIds,
    );
  });

  test('lenient defaults still reject malformed staff fields', () {
    final Map<String, dynamic> json = {
      'id': 'uid',
      'fullName': 'Ada',
      'email': 'a@example.com',
      ...staffFields,
    };
    for (final Object value in [
      42,
      'exam',
      [42],
    ]) {
      expect(
        () => DoctorModel.fromJson({...json, 'serviceIds': value}),
        throwsA(isA<CheckedFromJsonException>()),
      );
      expect(
        () => TechnicianModel.fromJson({...json, 'serviceIds': value}),
        throwsA(isA<CheckedFromJsonException>()),
      );
    }
    expect(
      () => DoctorModel.fromJson({...json, 'specialty': 42}),
      throwsA(isA<CheckedFromJsonException>()),
    );
  });
}
