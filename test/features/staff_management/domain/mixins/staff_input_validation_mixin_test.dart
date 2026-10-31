import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/models/staff_assignment.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/staff_fixtures.dart';
import '../doubles/staff_validation_probe.dart';

void main() {
  const StaffFixtures fixtures = StaffFixtures();
  final StaffValidationProbe validation = StaffValidationProbe();

  test('reports the first failure in the specified validation order', () {
    final List<String> excessive = List<String>.filled(21, 'unknown');
    final List<(Staff, UserErrorCode)> cases = [
      (
        fixtures.doctor(
          fullName: ' \t',
          email: 'bad',
          branchId: '',
          departmentId: '',
          specialty: '',
          serviceIds: excessive,
        ),
        UserErrorCode.fullNameRequired,
      ),
      (
        fixtures.doctor(
          email: 'bad',
          branchId: '',
          departmentId: '',
          specialty: '',
          serviceIds: excessive,
        ),
        UserErrorCode.invalidEmail,
      ),
      (
        fixtures.doctor(
          branchId: ' \n',
          departmentId: '',
          specialty: '',
          serviceIds: excessive,
        ),
        UserErrorCode.branchRequired,
      ),
      (
        fixtures.doctor(
          departmentId: ' \t',
          specialty: '',
          serviceIds: excessive,
        ),
        UserErrorCode.departmentRequired,
      ),
      (
        fixtures.doctor(specialty: '', serviceIds: excessive),
        UserErrorCode.specialtyRequired,
      ),
      (
        fixtures.doctor(specialty: ' \n ', serviceIds: excessive),
        UserErrorCode.specialtyRequired,
      ),
      (fixtures.doctor(serviceIds: excessive), UserErrorCode.tooManyServices),
      (
        fixtures.doctor(serviceIds: ['unknown', 'unknown']),
        UserErrorCode.duplicateService,
      ),
      (
        fixtures.doctor(serviceIds: ['unknown']),
        UserErrorCode.ineligibleService,
      ),
    ];
    for (final (Staff staff, UserErrorCode expected) in cases) {
      expect(
        validation.staffError(
          StaffAssignment(staff: staff, availableServices: fixtures.services()),
        ),
        expected,
        reason: expected.name,
      );
    }
  });

  test(
    'unknown, wrong-role and foreign services are ineligible for both roles',
    () {
      final List<(Staff, List<MedicalService>)> cases = [
        (fixtures.doctor(serviceIds: ['radiology']), fixtures.services()),
        (fixtures.doctor(serviceIds: ['lab']), fixtures.services()),
        (fixtures.technician(serviceIds: ['exam']), fixtures.services()),
        (fixtures.technician(serviceIds: ['missing']), fixtures.services()),
        (
          fixtures.doctor(serviceIds: ['exam']),
          fixtures.services(branchId: 'other'),
        ),
        (
          fixtures.doctor(serviceIds: ['exam']),
          fixtures.services(departmentId: 'other'),
        ),
        (
          fixtures.technician(serviceIds: ['lab']),
          fixtures.services(branchId: 'other'),
        ),
        (
          fixtures.technician(serviceIds: ['lab']),
          fixtures.services(departmentId: 'other'),
        ),
      ];
      for (final (Staff staff, List<MedicalService> services) in cases) {
        expect(
          validation.staffError(
            StaffAssignment(staff: staff, availableServices: services),
          ),
          UserErrorCode.ineligibleService,
        );
      }
    },
  );

  test('empty assignments and each role eligible assignments are valid', () {
    for (final Staff staff in [
      fixtures.doctor(email: ' ada@example.com '),
      fixtures.technician(),
      fixtures.doctor(serviceIds: ['exam']),
      fixtures.technician(serviceIds: ['radiology', 'lab']),
    ]) {
      expect(
        validation.staffError(
          StaffAssignment(staff: staff, availableServices: fixtures.services()),
        ),
        isNull,
      );
    }
  });

  test('twenty distinct eligible services are valid', () {
    final List<MedicalService> catalogue = List<MedicalService>.generate(
      20,
      (int index) => fixtures.services().first.withId('exam-$index'),
    );
    expect(
      validation.staffError(
        StaffAssignment(
          staff: fixtures.doctor(
            serviceIds: catalogue.map((MedicalService s) => s.id).toList(),
          ),
          availableServices: catalogue,
        ),
      ),
      isNull,
    );
  });

  test('ensureStaffValid throws the typed error and accepts null', () {
    expect(() => validation.ensureStaffValid(null), returnsNormally);
    for (final UserErrorCode error in UserErrorCode.values) {
      expect(
        () => validation.ensureStaffValid(error),
        throwsA(
          isA<UserException>().having(
            (UserException e) => e.code,
            'code',
            error,
          ),
        ),
      );
    }
  });
}
