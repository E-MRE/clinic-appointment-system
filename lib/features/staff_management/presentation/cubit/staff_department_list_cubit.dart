import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_of_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_cubit.dart';

/// Observes departments across the selected clinic branches.
final class StaffDepartmentListCubit
    extends
        InstitutionListCubit<
          Department,
          List<String>,
          WatchDepartmentsOfBranchesUseCase
        > {
  /// Injects the typed observation use case.
  StaffDepartmentListCubit(super.watchUseCase);

  /// Starts or replaces the observation.
  Future<void> watch(List<String> branchIds) => watchWith(branchIds);
}
