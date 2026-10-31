import 'dart:async';

import 'package:clinic_appointment_system/core/enums/auth_error_code.dart';
import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/create_staff_use_case.dart';
import 'package:clinic_appointment_system/features/staff_management/domain/usecases/update_staff_use_case.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_save_cubit.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/cubit/staff_save_state.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_form_values.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/visitors/staff_form_values_visitor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/doctor.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/technician.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../domain/doubles/fake_staff_account_provisioner.dart';
import '../../domain/doubles/fake_staff_repository.dart';
import '../../domain/doubles/staff_fixtures.dart';
import '../doubles/mock_staff_repository.dart';

void main() {
  const fixtures = StaffFixtures();
  const password = 'Valid-temporary-7';
  late FakeStaffAccountProvisioner provisioner;
  late FakeStaffRepository repository;
  late StaffSaveCubit cubit;
  late StaffFormValues values;

  setUpAll(() => registerFallbackValue(fixtures.doctor()));
  setUp(() {
    provisioner = FakeStaffAccountProvisioner();
    repository = FakeStaffRepository();
    cubit = StaffSaveCubit(
      CreateStaffUseCase(provisioner, repository),
      UpdateStaffUseCase(repository),
    );
    values = StaffFormValues.fromStaff(
      fixtures.doctor(serviceIds: ['exam']),
    ).copyWith(password: password);
  });
  tearDown(() => cubit.close());

  test(
    'create emits saving then saved and passes normalized profile and exact password',
    () async {
      expect(cubit.state, isA<StaffSaveInitial>());
      final emissions = expectLater(
        cubit.stream,
        emitsInOrder([isA<StaffSaveSaving>(), isA<StaffSaveSaved>()]),
      );
      await cubit.create(
        values.copyWith(fullName: '  Updated  ', email: '  ada@example.com  '),
        availableServices: fixtures.services(),
      );
      await emissions;
      expect(repository.createdStaff?.id, 'new-uid');
      expect(repository.createdStaff?.fullName, 'Updated');
      expect(repository.createdStaff?.email, 'ada@example.com');
      expect(repository.createdStaff?.serviceIds, ['exam']);
      expect(provisioner.receivedCredentials?.password, password);
      expect(
        cubit.state,
        isA<StaffSaveSaved>().having(
          (state) => state.staff.id,
          'id',
          'new-uid',
        ),
      );
    },
  );

  test('emailAlreadyInUse maps to auth failure', () async {
    provisioner.creationException = const AuthException(
      AuthErrorCode.emailAlreadyInUse,
    );
    await cubit.create(values, availableServices: fixtures.services());
    expect(
      cubit.state,
      isA<StaffSaveAuthFailure>().having(
        (state) => state.code,
        'code',
        AuthErrorCode.emailAlreadyInUse,
      ),
    );
  });

  test('orphanAccount maps to profile failure', () async {
    repository.createException = const UserException(UserErrorCode.unavailable);
    provisioner.deleteFails = true;
    await cubit.create(values, availableServices: fixtures.services());
    expect(
      cubit.state,
      isA<StaffSaveProfileFailure>().having(
        (state) => state.code,
        'code',
        UserErrorCode.orphanAccount,
      ),
    );
  });

  test(
    'use case validation maps profile failure before provisioning',
    () async {
      await cubit.create(
        values.copyWith(fullName: ''),
        availableServices: fixtures.services(),
      );
      expect(
        cubit.state,
        isA<StaffSaveProfileFailure>().having(
          (state) => state.code,
          'code',
          UserErrorCode.fullNameRequired,
        ),
      );
      expect(provisioner.provisionCalls, isZero);
    },
  );

  test(
    'unexpected exceptions and errors map to unexpected auth failure',
    () async {
      for (final error in [Exception('unexpected'), StateError('unexpected')]) {
        provisioner.creationException = error;
        await cubit.create(values, availableServices: fixtures.services());
        expect(
          cubit.state,
          isA<StaffSaveAuthFailure>().having(
            (state) => state.code,
            'code',
            AuthErrorCode.unexpected,
          ),
        );
      }
    },
  );

  test(
    'unsuccessful create result maps to unavailable profile failure',
    () async {
      provisioner.result = const DataResult.error();
      await cubit.create(values, availableServices: fixtures.services());
      expect(
        cubit.state,
        isA<StaffSaveProfileFailure>().having(
          (state) => state.code,
          'code',
          UserErrorCode.unavailable,
        ),
      );
    },
  );

  test(
    'unsuccessful and missing-data update results map to unavailable',
    () async {
      for (final result in <DataResult<Staff>>[
        const DataResult.error(),
        const DataResult.success(data: null),
      ]) {
        repository.updateResult = result;
        await cubit.update(
          values,
          original: fixtures.doctor(id: 'original'),
          availableServices: fixtures.services(),
        );
        expect(
          cubit.state,
          isA<StaffSaveProfileFailure>().having(
            (state) => state.code,
            'code',
            UserErrorCode.unavailable,
          ),
        );
      }
    },
  );

  test(
    'update locks doctor role, email, branch and department before building',
    () async {
      final original = fixtures.doctor(id: 'original-doctor');
      final tampered = values.copyWith(
        role: UserRole.technician,
        email: 'other@example.com',
        branchId: 'other-branch',
        departmentId: 'other-department',
        fullName: '  New Name  ',
        specialty: '  New Specialty  ',
      );
      await cubit.update(
        tampered,
        original: original,
        availableServices: fixtures.services(),
      );
      final updated = repository.updatedStaff;
      expect(updated, isA<Doctor>());
      expect(updated?.id, original.id);
      expect(updated?.role, original.role);
      expect(updated?.email, original.email);
      expect(updated?.branchId, original.branchId);
      expect(updated?.departmentId, original.departmentId);
      expect(updated?.fullName, 'New Name');
      expect(updated?.serviceIds, ['exam']);
      expect(
        updated?.accept(const StaffFormValuesVisitor()).specialty,
        'New Specialty',
      );
      expect(
        cubit.state,
        isA<StaffSaveSaved>().having((state) => state.staff, 'staff', updated),
      );
      expect(provisioner.provisionCalls, isZero);
    },
  );

  test(
    'update locks technician role even when form carries unsupported admin role',
    () async {
      final original = fixtures.technician(id: 'original-technician');
      await cubit.update(
        values.copyWith(
          role: UserRole.admin,
          email: '',
          branchId: '',
          departmentId: '',
          specialty: 'ignored',
          serviceIds: ['lab'],
        ),
        original: original,
        availableServices: fixtures.services(),
      );
      final updated = repository.updatedStaff;
      expect(updated, isA<Technician>());
      expect(updated?.id, original.id);
      expect(updated?.role, original.role);
      expect(updated?.email, original.email);
      expect(updated?.branchId, original.branchId);
      expect(updated?.departmentId, original.departmentId);
      expect(updated?.serviceIds, ['lab']);
      expect(cubit.state, isA<StaffSaveSaved>());
    },
  );

  test(
    'single-flight ignores create and update while creation is saving',
    () async {
      final gate = Completer<DataResult<Staff>>();
      final slowRepository = MockStaffRepository();
      when(
        () => slowRepository.createStaff(any()),
      ).thenAnswer((_) => gate.future);
      final slowCubit = StaffSaveCubit(
        CreateStaffUseCase(provisioner, slowRepository),
        UpdateStaffUseCase(slowRepository),
      );
      addTearDown(slowCubit.close);
      final pending = slowCubit.create(
        values,
        availableServices: fixtures.services(),
      );
      await slowCubit.create(values, availableServices: fixtures.services());
      await slowCubit.update(
        values,
        original: fixtures.doctor(id: 'original'),
        availableServices: fixtures.services(),
      );
      expect(slowCubit.state, isA<StaffSaveSaving>());
      const expectedCalls = 1;
      expect(provisioner.provisionCalls, expectedCalls);
      verify(() => slowRepository.createStaff(any())).called(expectedCalls);
      verifyNever(() => slowRepository.updateStaff(any()));
      gate.complete(DataResult.success(data: fixtures.doctor(id: 'new-uid')));
      await pending;
      expect(slowCubit.state, isA<StaffSaveSaved>());
    },
  );

  test('late create success and failures after close emit no result', () async {
    for (final Object? error in [
      null,
      const AuthException(AuthErrorCode.emailAlreadyInUse),
      const UserException(UserErrorCode.orphanAccount),
      StateError('late'),
    ]) {
      final gate = Completer<DataResult<Staff>>();
      final slowRepository = MockStaffRepository();
      when(
        () => slowRepository.createStaff(any()),
      ).thenAnswer((_) => gate.future);
      final slowCubit = StaffSaveCubit(
        CreateStaffUseCase(provisioner, slowRepository),
        UpdateStaffUseCase(slowRepository),
      );
      final states = <StaffSaveState>[];
      final subscription = slowCubit.stream.listen(states.add);
      final pending = slowCubit.create(
        values,
        availableServices: fixtures.services(),
      );
      await slowCubit.close();
      if (error == null) {
        gate.complete(DataResult.success(data: fixtures.doctor(id: 'late')));
      } else {
        gate.completeError(error);
      }
      await pending;
      await subscription.cancel();
      expect(states, [isA<StaffSaveSaving>()]);
      expect(slowCubit.state, isA<StaffSaveSaving>());
      await slowCubit.create(values, availableServices: fixtures.services());
      verify(() => slowRepository.createStaff(any())).called(1);
    }
  });

  test(
    'update is single-flight and ignores a late result after close',
    () async {
      final gate = Completer<DataResult<Staff>>();
      final slowRepository = MockStaffRepository();
      when(
        () => slowRepository.updateStaff(any()),
      ).thenAnswer((_) => gate.future);
      final slowCubit = StaffSaveCubit(
        CreateStaffUseCase(provisioner, slowRepository),
        UpdateStaffUseCase(slowRepository),
      );
      final original = fixtures.doctor(id: 'original');
      final pending = slowCubit.update(
        values,
        original: original,
        availableServices: fixtures.services(),
      );
      await slowCubit.update(
        values,
        original: original,
        availableServices: fixtures.services(),
      );
      await slowCubit.create(values, availableServices: fixtures.services());
      await slowCubit.close();
      gate.complete(DataResult.success(data: original));
      await pending;
      expect(slowCubit.state, isA<StaffSaveSaving>());
      await slowCubit.update(
        values,
        original: original,
        availableServices: fixtures.services(),
      );
      verify(() => slowRepository.updateStaff(any())).called(1);
      verifyNever(() => slowRepository.createStaff(any()));
    },
  );
}
