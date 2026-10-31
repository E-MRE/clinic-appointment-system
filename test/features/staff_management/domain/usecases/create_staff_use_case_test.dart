import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/models/staff_registration.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/create_staff_use_case.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:flutter_test/flutter_test.dart';

import '../doubles/fake_staff_account_provisioner.dart';
import '../doubles/fake_staff_repository.dart';
import '../doubles/staff_fixtures.dart';

void main() {
  const StaffFixtures fixtures = StaffFixtures();
  late FakeStaffAccountProvisioner provisioner;
  late FakeStaffRepository repository;
  late CreateStaffUseCase useCase;

  setUp(() {
    provisioner = FakeStaffAccountProvisioner();
    repository = FakeStaffRepository();
    useCase = CreateStaffUseCase(provisioner, repository);
  });

  test('invalid credentials never create an account or profile', () async {
    final List<(String, String, AuthErrorCode)> cases = [
      ('bad', 'validPass9', AuthErrorCode.invalidEmail),
      ('ada@example.com', '', AuthErrorCode.missingPassword),
      ('ada@example.com', 'short7', AuthErrorCode.passwordTooShort),
      ('bad', '', AuthErrorCode.invalidEmail),
    ];
    for (final (String email, String password, AuthErrorCode expected)
        in cases) {
      await expectLater(
        useCase(
          StaffRegistration(
            staff: fixtures.doctor(email: email),
            password: password,
            availableServices: fixtures.services(),
          ),
        ),
        throwsA(
          isA<AuthException>().having(
            (AuthException e) => e.code,
            'code',
            expected,
          ),
        ),
      );
    }
    expect(provisioner.provisionCalls, 0);
    expect(repository.createCalls, 0);
  });

  test('invalid staff never reaches the provisioner', () async {
    final List<(Staff, UserErrorCode)> cases = [
      (fixtures.doctor(fullName: ' '), UserErrorCode.fullNameRequired),
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
      (fixtures.doctor(serviceIds: ['lab']), UserErrorCode.ineligibleService),
    ];
    for (final (Staff staff, UserErrorCode expected) in cases) {
      await expectLater(
        useCase(
          StaffRegistration(
            staff: staff,
            password: 'validPass9',
            availableServices: fixtures.services(),
          ),
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
    expect(provisioner.provisionCalls, 0);
    expect(repository.createCalls, 0);
  });

  test('auth validation precedes staff validation', () async {
    await expectLater(
      useCase(
        StaffRegistration(
          staff: fixtures.doctor(fullName: '', email: 'bad'),
          password: '',
          availableServices: const [],
        ),
      ),
      throwsA(
        isA<AuthException>().having(
          (AuthException e) => e.code,
          'code',
          AuthErrorCode.invalidEmail,
        ),
      ),
    );
    expect(provisioner.provisionCalls, 0);
  });

  for (final AuthErrorCode code in [
    AuthErrorCode.emailAlreadyInUse,
    AuthErrorCode.weakPassword,
  ]) {
    test('propagates account creation failure $code', () async {
      final AuthException error = AuthException(code);
      provisioner.creationException = error;
      await expectLater(
        useCase(
          StaffRegistration(
            staff: fixtures.doctor(),
            password: 'validPass9',
            availableServices: const [],
          ),
        ),
        throwsA(same(error)),
      );
      expect(repository.createCalls, 0);
      expect(provisioner.signedOut, isTrue);
    });
  }

  test(
    'profile failure propagates with original identity after rollback',
    () async {
      const UserException error = UserException(UserErrorCode.unavailable);
      repository.createException = error;
      await expectLater(
        useCase(
          StaffRegistration(
            staff: fixtures.doctor(),
            password: 'validPass9',
            availableServices: const [],
          ),
        ),
        throwsA(same(error)),
      );
      expect(provisioner.deletedUids, ['new-uid']);
      expect(provisioner.signedOut, isTrue);
      expect(repository.createdStaff, isNull);
    },
  );

  test('failed rollback reports orphanAccount', () async {
    repository.createException = const UserException(UserErrorCode.unavailable);
    provisioner.deleteFails = true;
    await expectLater(
      useCase(
        StaffRegistration(
          staff: fixtures.doctor(),
          password: 'validPass9',
          availableServices: const [],
        ),
      ),
      throwsA(
        isA<UserException>().having(
          (UserException e) => e.code,
          'code',
          UserErrorCode.orphanAccount,
        ),
      ),
    );
    expect(provisioner.signedOut, isTrue);
  });

  test('non-success or null uid never writes a profile', () async {
    for (final DataResult<String> failure in [
      const DataResult<String>.error(message: 'rejected'),
      const DataResult<String>.error(
        data: 'unexpected-uid',
        message: 'rejected',
      ),
      const DataResult<String>.success(data: null, message: 'missing uid'),
    ]) {
      provisioner.result = failure;
      final DataResult<Staff> response = await useCase(
        StaffRegistration(
          staff: fixtures.doctor(),
          password: 'validPass9',
          availableServices: const [],
        ),
      );
      expect(response.isNotSuccess, isTrue);
      expect(response.data, isNull);
      expect(response.message, failure.message);
    }
    expect(repository.createCalls, 0);
  });

  test('creates doctor with provisioned uid and trimmed profile', () async {
    final DataResult<Staff> response = await useCase(
      StaffRegistration(
        staff: fixtures.doctor(
          id: 'untrusted-id',
          fullName: ' Ada Kaya ',
          email: ' ada@example.com ',
          branchId: ' branch ',
          departmentId: ' department ',
          specialty: ' Cardiology ',
          serviceIds: [' exam '],
        ),
        password: ' validPass9 ',
        availableServices: fixtures.services(),
      ),
    );
    expect(response.isSuccess, isTrue);
    final Staff? saved = repository.createdStaff;
    expect(
      saved,
      isA<Doctor>().having(
        (Doctor d) => d.specialty,
        'specialty',
        'Cardiology',
      ),
    );
    expect(saved?.id, 'new-uid');
    expect(saved?.fullName, 'Ada Kaya');
    expect(saved?.email, 'ada@example.com');
    expect(saved?.branchId, 'branch');
    expect(saved?.departmentId, 'department');
    expect(saved?.serviceIds, ['exam']);
    expect(response.data?.id, 'new-uid');
    expect(response.data?.serviceIds, ['exam']);
    expect(provisioner.receivedCredentials?.email, 'ada@example.com');
    expect(provisioner.receivedCredentials?.password, ' validPass9 ');
    expect(provisioner.deletedUids, isEmpty);
    expect(provisioner.signedOut, isTrue);
  });

  test('creates technician with diagnostic services', () async {
    final DataResult<Staff> response = await useCase(
      StaffRegistration(
        staff: fixtures.technician(serviceIds: [' lab ', ' radiology ']),
        password: 'validPass9',
        availableServices: fixtures.services(),
      ),
    );
    expect(response.data, isA<Technician>());
    expect(repository.createdStaff?.id, 'new-uid');
    expect(repository.createdStaff?.serviceIds, ['lab', 'radiology']);
  });

  test(
    'registration exposes credentials without exposing its password in text',
    () {
      final StaffRegistration registration = StaffRegistration(
        staff: fixtures.doctor(),
        password: 'privatePass9',
        availableServices: const [],
      );
      expect(registration.credentials.email, 'ada@example.com');
      expect(registration.credentials.password, 'privatePass9');
      expect(registration.toString(), isNot(contains('privatePass9')));
      expect(
        registration.credentials.toString(),
        isNot(contains('privatePass9')),
      );
    },
  );
}
