import 'package:clinic_appointment_system/features/users/domain/entities/admin.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/patient.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final profiles = <(User, Map<String, dynamic>)>[
    (
      const Patient(id: 'uid', fullName: 'Elif', email: 'e@test.com'),
      {'role': 'patient', 'fullName': 'Elif', 'email': 'e@test.com'},
    ),
    (
      const Admin(id: 'uid', fullName: 'Elif', email: 'e@test.com'),
      {'role': 'admin', 'fullName': 'Elif', 'email': 'e@test.com'},
    ),
    (
      const Doctor(
        id: 'uid',
        fullName: 'Elif',
        email: 'e@test.com',
        branchId: 'b',
        departmentId: 'd',
      ),
      {
        'role': 'doctor',
        'fullName': 'Elif',
        'email': 'e@test.com',
        'branchId': 'b',
        'departmentId': 'd',
      },
    ),
    (
      const Technician(
        id: 'uid',
        fullName: 'Elif',
        email: 'e@test.com',
        branchId: 'b',
        departmentId: 'd',
      ),
      {
        'role': 'technician',
        'fullName': 'Elif',
        'email': 'e@test.com',
        'branchId': 'b',
        'departmentId': 'd',
      },
    ),
  ];
  for (final (profile, json) in profiles) {
    test('${profile.role.name} JSON round trip', () {
      final encoded = switch (profile) {
        final Patient p => p.toJson(),
        final Admin a => a.toJson(),
        final Doctor d => d.toJson(),
        final Technician t => t.toJson(),
        _ => throw StateError('Unknown profile'),
      };
      expect(encoded, json);
      final decoded = User.fromJson({...json, 'id': 'uid'});
      expect(decoded.runtimeType, profile.runtimeType);
      expect(decoded.id, profile.id);
      expect(decoded.fullName, profile.fullName);
      expect(decoded.email, profile.email);
      if (decoded is Doctor) {
        expect(decoded.branchId, 'b');
        expect(decoded.departmentId, 'd');
      }
      if (decoded is Technician) {
        expect(decoded.branchId, 'b');
        expect(decoded.departmentId, 'd');
      }
    });
  }
  test('unknown and missing roles fail', () {
    expect(() => User.fromJson({'role': 'unknown'}), throwsArgumentError);
    expect(() => User.fromJson({}), throwsA(isA<TypeError>()));
  });
  test('missing required profile fields fail', () {
    expect(
      () => User.fromJson({'role': 'patient', 'id': 'uid', 'email': 'e'}),
      throwsA(isA<Exception>()),
    );
    for (final role in ['doctor', 'technician']) {
      for (final field in ['branchId', 'departmentId']) {
        final json = {
          'role': role,
          'id': 'uid',
          'fullName': 'Elif',
          'email': 'e',
          'branchId': 'b',
          'departmentId': 'd',
        }..remove(field);
        expect(() => User.fromJson(json), throwsA(isA<Exception>()));
      }
    }
  });
}
