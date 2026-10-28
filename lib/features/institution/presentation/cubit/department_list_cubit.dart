import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_use_case.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_cubit.dart';

/// Observes the departments belonging to one branch at a time.
final class DepartmentListCubit
    extends InstitutionListCubit<Department, String, WatchDepartmentsUseCase> {
  /// Creates a department observer whose first branch is supplied by [watch].
  DepartmentListCubit(super.watchUseCase);

  /// Starts or replaces the department observation for [branchId].
  Future<void> watch(String branchId) {
    return watchWith(branchId);
  }
}
