import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_list_state.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:clinic_appointment_system/features/users/presentation/extensions/user_role_staff_label.dart';

/// Builds staff identity text from the available department catalogue.
extension StaffAvailabilitySubtitle on InstitutionListState<Department> {
  /// Combines the staff name and role with its department when known.
  String subtitleFor(Staff staff) {
    final department = _departmentNameOf(staff.departmentId);
    return [staff.fullName, staff.role.staffLabel, ?department].join(' · ');
  }

  String? _departmentNameOf(String departmentId) {
    final current = this;
    if (current is InstitutionListLoaded<Department>) {
      for (final department in current.items) {
        if (department.id == departmentId) return department.name;
      }
    }
    return null;
  }
}
