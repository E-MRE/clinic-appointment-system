import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/models/staff_assignment.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/update_staff_use_case.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/fake_staff_repository.dart';
import '../doubles/staff_fixtures.dart';

void main() {
  const StaffFixtures fixtures = StaffFixtures();

  test(
    'trims profile and assigned ids, preserving id and repository result',
    () async {
      final FakeStaffRepository repository = FakeStaffRepository();
      final DataResult<Staff> expected = DataResult.success(
        data: fixtures.doctor(),
      );
      repository.updateResult = expected;
      final DataResult<Staff> result = await UpdateStaffUseCase(repository)(
        StaffAssignment(
          staff: fixtures.doctor(
            id: 'uid',
            fullName: ' Ada Kaya ',
            email: ' ada@example.com ',
            branchId: ' branch ',
            departmentId: ' department ',
            specialty: ' Cardiology ',
            serviceIds: [' exam '],
          ),
          availableServices: fixtures.services(),
        ),
      );
      expect(result, same(expected));
      final Staff? saved = repository.updatedStaff;
      expect(saved?.id, 'uid');
      expect(saved?.fullName, 'Ada Kaya');
      expect(saved?.email, 'ada@example.com');
      expect(saved?.branchId, 'branch');
      expect(saved?.departmentId, 'department');
      expect(saved?.serviceIds, ['exam']);
      expect(
        saved,
        isA<Doctor>().having(
          (Doctor d) => d.specialty,
          'specialty',
          'Cardiology',
        ),
      );
    },
  );

  test('invalid input is rejected before updating', () async {
    final FakeStaffRepository repository = FakeStaffRepository();
    final UpdateStaffUseCase useCase = UpdateStaffUseCase(repository);
    final List<(Staff, UserErrorCode)> cases = [
      (fixtures.doctor(fullName: ''), UserErrorCode.fullNameRequired),
      (fixtures.doctor(email: 'bad'), UserErrorCode.invalidEmail),
      (fixtures.doctor(branchId: ''), UserErrorCode.branchRequired),
      (fixtures.doctor(departmentId: ''), UserErrorCode.departmentRequired),
      (fixtures.doctor(specialty: ' '), UserErrorCode.specialtyRequired),
      (
        fixtures.doctor(serviceIds: List<String>.filled(21, 'exam')),
        UserErrorCode.tooManyServices,
      ),
      (
        fixtures.doctor(serviceIds: [' exam ', 'exam']),
        UserErrorCode.duplicateService,
      ),
      (
        fixtures.technician(serviceIds: ['exam']),
        UserErrorCode.ineligibleService,
      ),
    ];
    for (final (Staff staff, UserErrorCode expected) in cases) {
      await expectLater(
        useCase(
          StaffAssignment(staff: staff, availableServices: fixtures.services()),
        ),
        throwsA(
          isA<UserException>().having(
            (UserException e) => e.code,
            'code',
            expected,
          ),
        ),
      );
    }
    expect(repository.updateCalls, 0);
  });

  test('forwards repository errors and unsuccessful results', () async {
    final FakeStaffRepository repository = FakeStaffRepository();
    final UpdateStaffUseCase useCase = UpdateStaffUseCase(repository);
    final StaffAssignment assignment = StaffAssignment(
      staff: fixtures.technician(serviceIds: ['lab']),
      availableServices: fixtures.services(),
    );
    const UserException error = UserException(UserErrorCode.unavailable);
    repository.updateException = error;
    await expectLater(useCase(assignment), throwsA(same(error)));
    repository.updateException = null;
    const DataResult<Staff> failure = DataResult.error(message: 'unavailable');
    repository.updateResult = failure;
    expect(await useCase(assignment), same(failure));
  });
}
