import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/watch_departments_of_branches_use_case.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_cubit.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/services/staff_availability_subtitle_formatter.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Observes departments across the selected clinic branches.
final class StaffDepartmentListCubit
    extends
        InstitutionListCubit<
          Department,
          List<String>,
          WatchDepartmentsOfBranchesUseCase
        > {
  /// Injects the typed observation use case.
  StaffDepartmentListCubit(super.watchUseCase, this._subtitleFormatter);

  final StaffAvailabilitySubtitleFormatter _subtitleFormatter;

  /// Starts or replaces the observation.
  Future<void> watch(List<String> branchIds) => watchWith(branchIds);

  /// Formats [staff] with the department from the currently loaded catalogue.
  String subtitleFor(Staff staff, {required String roleLabel}) {
    final current = state;
    final departments = current is InstitutionListLoaded<Department>
        ? current.items
        : const <Department>[];
    return _subtitleFormatter.format(
      staff: staff,
      roleLabel: roleLabel,
      departments: departments,
    );
  }
}
