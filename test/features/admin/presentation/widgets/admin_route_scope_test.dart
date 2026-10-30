import 'package:clinic_appointment_system/core/di/app_dependency.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/features/admin/presentation/widgets/admin_route_scope.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/branch_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/clinic_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/branch_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/clinic_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_clinics_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/branch_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/clinic_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/department_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection.dart';
import 'package:clinic_appointment_system/features/institution/presentation/pages/institution_selection_scope.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../institution/domain/doubles/fake_department_repository.dart';

final class _ReplayableBranchRepository implements BranchRepository {
  _ReplayableBranchRepository(this._branches);

  final List<Branch> _branches;
  String? watchedClinicId;

  @override
  Stream<DataResult<List<Branch>>> watchBranches(String clinicId) {
    watchedClinicId = clinicId;
    return Stream.value(DataResult.success(data: _branches));
  }

  @override
  Future<DataResult<Branch>> createBranch(BranchDraft draft) =>
      throw UnimplementedError();

  @override
  Future<DataResult<Branch>> updateBranch(Branch branch) =>
      throw UnimplementedError();
}

final class _ReplayableClinicRepository implements ClinicRepository {
  _ReplayableClinicRepository(this._clinics);

  final List<Clinic> _clinics;

  @override
  Stream<DataResult<List<Clinic>>> watchClinics() {
    return Stream.value(DataResult.success(data: _clinics));
  }

  @override
  Future<DataResult<Clinic>> createClinic(ClinicDraft draft) =>
      throw UnimplementedError();

  @override
  Future<DataResult<Clinic>> updateClinic(Clinic clinic) =>
      throw UnimplementedError();
}

void main() {
  tearDown(() async => AppDependency.injector.reset());

  testWidgets(
    'AdminRouteScope processes already-loaded clinic and branch states at initState',
    (tester) async {
      const clinic = Clinic(id: 'c1', name: 'Preloaded Clinic');
      final branch = Branch(
        id: 'b1',
        clinicId: 'c1',
        name: 'Preloaded Branch',
        address: 'Main Street',
        workingHours: WorkingHours.closed(),
      );

      final clinicRepo = _ReplayableClinicRepository([clinic]);
      final branchRepo = _ReplayableBranchRepository([branch]);
      final deptRepo = FakeDepartmentRepository()
        ..departmentsStream = const Stream.empty();

      final clinicCubit = ClinicListCubit(WatchClinicsUseCase(clinicRepo));
      final branchCubit = BranchListCubit(WatchBranchesUseCase(branchRepo));
      final deptCubit = DepartmentListCubit(WatchDepartmentsUseCase(deptRepo));

      await branchCubit.watch('c1');
      await tester.pump();

      expect(clinicCubit.state, isA<InstitutionListLoaded<Clinic>>());
      expect(branchCubit.state, isA<InstitutionListLoaded<Branch>>());

      AppDependency.injector.registerFactory<ClinicListCubit>(
        () => clinicCubit,
      );
      AppDependency.injector.registerFactory<BranchListCubit>(
        () => branchCubit,
      );
      AppDependency.injector.registerFactory<DepartmentListCubit>(
        () => deptCubit,
      );

      InstitutionSelection? capturedSelection;

      await tester.pumpWidget(
        MaterialApp(
          theme: LightTheme(ScreenSize.mobile).themeData,
          home: AdminRouteScope(
            child: Builder(
              builder: (childContext) {
                capturedSelection = InstitutionSelectionScope.read(
                  childContext,
                );
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      await tester.pump();

      expect(capturedSelection, isNotNull);
      expect(capturedSelection?.clinicId, 'c1');
      expect(capturedSelection?.branchId, 'b1');
      expect(deptRepo.watchedBranchId, 'b1');
    },
  );
}
