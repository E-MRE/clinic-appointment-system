import 'package:clinic_appointment_system/features/staff_management/presentation/enums/staff_role_filter.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_filter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Tracks role and department-name filters for staff views.
final class StaffFilterCubit extends Cubit<StaffFilter> {
  /// Creates a filter matching every staff member.
  StaffFilterCubit() : super(const StaffFilter());

  /// Selects the role category while preserving the department.
  void selectRole(StaffRoleFilter role) => emit(state.copyWith(role: role));

  /// Selects a department name, or clears the selection when null.
  void selectDepartment(String? name) {
    if (name == null) {
      emit(state.withoutDepartment());
    } else {
      emit(state.copyWith(departmentName: name));
    }
  }
}
