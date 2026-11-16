import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Formats staff identity and a known department name for availability headers.
final class StaffAvailabilitySubtitleFormatter {
  /// Creates a formatter with no external dependencies.
  const StaffAvailabilitySubtitleFormatter();

  /// Combines [staff] identity, [roleLabel] and its known department name.
  String format({
    required Staff staff,
    required String roleLabel,
    required Iterable<Department> departments,
  }) {
    final department = _departmentNameOf(staff.departmentId, departments);
    return [staff.fullName, roleLabel, ?department].join(' · ');
  }

  String? _departmentNameOf(
    String departmentId,
    Iterable<Department> departments,
  ) {
    for (final department in departments) {
      if (department.id == departmentId) return department.name;
    }
    return null;
  }
}
