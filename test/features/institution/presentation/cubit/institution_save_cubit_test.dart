import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/branch_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/clinic_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/department_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/branch_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/clinic_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/department_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/create_branch_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/create_clinic_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/create_department_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/update_branch_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/update_clinic_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/update_department_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_save_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_save_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('clinic save cubit', () {
    late _ClinicRepository repository;
    late ClinicSaveCubit cubit;

    setUp(() {
      repository = _ClinicRepository();
      cubit = ClinicSaveCubit(
        CreateClinicUseCase(repository),
        UpdateClinicUseCase(repository),
      );
    });

    tearDown(() => cubit.close());

    test('creates and updates a clinic through saved states', () async {
      const created = Clinic(id: 'clinic-1', name: 'North Clinic');
      repository.createAction = (_) async =>
          const DataResult.success(data: created);

      await cubit.create('North Clinic');
      expect(
        cubit.state,
        isA<InstitutionSaveSaved<Clinic>>().having(
          (state) => state.value,
          'value',
          created,
        ),
      );

      const existing = Clinic(id: 'clinic-1', name: 'Old Name');
      const updated = Clinic(id: 'clinic-1', name: 'New Name');
      repository.updateAction = (_) async =>
          const DataResult.success(data: updated);
      await cubit.update(existing, 'New Name');

      expect(repository.updatedClinic?.name, 'New Name');
      expect(repository.updatedClinic?.id, 'clinic-1');
      expect(
        cubit.state,
        isA<InstitutionSaveSaved<Clinic>>().having(
          (state) => state.value,
          'value',
          updated,
        ),
      );
    });

    test('domain validation failures keep their institution code', () async {
      await cubit.create('  ');

      expect(repository.createCalls, 0);
      expect(
        cubit.state,
        isA<InstitutionSaveFailure<Clinic>>().having(
          (state) => state.code,
          'code',
          InstitutionErrorCode.nameRequired,
        ),
      );
    });

    test(
      'unexpected exceptions and error results map to unavailable',
      () async {
        repository.createAction = (_) async =>
            throw Exception('provider detail');
        await cubit.create('North Clinic');
        expect(
          cubit.state,
          isA<InstitutionSaveFailure<Clinic>>().having(
            (state) => state.code,
            'code',
            InstitutionErrorCode.unavailable,
          ),
        );

        repository.createAction = (_) async => const DataResult.error();
        await cubit.create('North Clinic');
        expect(
          cubit.state,
          isA<InstitutionSaveFailure<Clinic>>().having(
            (state) => state.code,
            'code',
            InstitutionErrorCode.unavailable,
          ),
        );
      },
    );

    test(
      'ignores a second request while saving and completion after close',
      () async {
        final pending = Completer<DataResult<Clinic>>();
        repository.createAction = (_) => pending.future;
        final first = cubit.create('North Clinic');
        int updateCalls = 0;
        repository.updateAction = (_) async {
          updateCalls++;
          return const DataResult.error();
        };
        await cubit.update(const Clinic(id: 'clinic-1', name: 'Old'), 'New');
        expect(updateCalls, 0);

        await cubit.close();
        pending.complete(
          const DataResult.success(
            data: Clinic(id: 'clinic-1', name: 'North Clinic'),
          ),
        );
        await first;
        expect(cubit.state, isA<InstitutionSaveSaving<Clinic>>());
      },
    );
  });

  test('branch create and update use the injected operations', () async {
    final repository = _BranchRepository();
    final cubit = BranchSaveCubit(
      CreateBranchUseCase(repository),
      UpdateBranchUseCase(repository),
    );
    final hours = WorkingHours.closed();
    final branch = Branch(
      id: 'branch-1',
      name: 'Central',
      clinicId: 'clinic-1',
      address: 'Main street',
      workingHours: hours,
    );
    repository.createAction = (_) async => DataResult.success(data: branch);

    await cubit.create(
      BranchDraft(
        clinicId: 'clinic-1',
        name: 'Central',
        address: 'Main street',
        workingHours: hours,
      ),
    );
    expect(cubit.state, isA<InstitutionSaveSaved<Branch>>());
    expect(repository.createdDraft?.clinicId, 'clinic-1');

    repository.updateAction = (_) async => DataResult.success(data: branch);
    await cubit.update(branch);
    expect(cubit.state, isA<InstitutionSaveSaved<Branch>>());
    expect(repository.updatedBranch?.id, 'branch-1');
    await cubit.close();
  });

  test('department create and update use the injected operations', () async {
    final repository = _DepartmentRepository();
    final cubit = DepartmentSaveCubit(
      CreateDepartmentUseCase(repository),
      UpdateDepartmentUseCase(repository),
    );
    const department = Department(
      id: 'department-1',
      branchId: 'branch-1',
      name: 'Cardiology',
    );
    repository.createAction = (_) async =>
        const DataResult.success(data: department);

    await cubit.create('branch-1', 'Cardiology');
    expect(cubit.state, isA<InstitutionSaveSaved<Department>>());
    expect(repository.createdBranchId, 'branch-1');

    repository.updateAction = (_) async =>
        const DataResult.success(data: department);
    await cubit.update(department, 'Cardiology');
    expect(repository.updatedDepartment?.name, 'Cardiology');
    expect(cubit.state, isA<InstitutionSaveSaved<Department>>());
    await cubit.close();
  });
}

final class _ClinicRepository implements ClinicRepository {
  Future<DataResult<Clinic>> Function(ClinicDraft draft) createAction =
      (_) async => const DataResult.error();
  Future<DataResult<Clinic>> Function(Clinic clinic) updateAction = (_) async =>
      const DataResult.error();
  Clinic? updatedClinic;
  int createCalls = 0;

  @override
  Future<DataResult<Clinic>> createClinic(ClinicDraft draft) {
    createCalls++;
    return createAction(draft);
  }

  @override
  Future<DataResult<Clinic>> updateClinic(Clinic clinic) {
    updatedClinic = clinic;
    return updateAction(clinic);
  }

  @override
  Stream<DataResult<List<Clinic>>> watchClinics() => const Stream.empty();
}

final class _BranchRepository implements BranchRepository {
  Future<DataResult<Branch>> Function(BranchDraft draft) createAction =
      (_) async => const DataResult.error();
  Future<DataResult<Branch>> Function(Branch branch) updateAction = (_) async =>
      const DataResult.error();
  BranchDraft? createdDraft;
  Branch? updatedBranch;

  @override
  Future<DataResult<Branch>> createBranch(BranchDraft draft) {
    createdDraft = draft;
    return createAction(draft);
  }

  @override
  Future<DataResult<Branch>> updateBranch(Branch branch) {
    updatedBranch = branch;
    return updateAction(branch);
  }

  @override
  Stream<DataResult<List<Branch>>> watchBranches(String clinicId) =>
      const Stream.empty();
}

final class _DepartmentRepository implements DepartmentRepository {
  Future<DataResult<Department>> Function(DepartmentDraft draft) createAction =
      (_) async => const DataResult.error();
  Future<DataResult<Department>> Function(Department department) updateAction =
      (_) async => const DataResult.error();
  String? createdBranchId;
  Department? updatedDepartment;

  @override
  Future<DataResult<Department>> createDepartment(DepartmentDraft draft) {
    createdBranchId = draft.branchId;
    return createAction(draft);
  }

  @override
  Future<DataResult<Department>> updateDepartment(Department department) {
    updatedDepartment = department;
    return updateAction(department);
  }

  @override
  Stream<DataResult<List<Department>>> watchDepartments(String branchId) =>
      const Stream.empty();
  @override
  Stream<DataResult<List<Department>>> watchDepartmentsOfBranches(
    List<String> branchIds,
  ) => const Stream.empty();
}
