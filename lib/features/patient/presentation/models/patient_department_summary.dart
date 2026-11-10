import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';

/// A department that offers bookable services, with their count.
final class PatientDepartmentSummary {
  /// Pairs [department] with its [serviceCount].
  const PatientDepartmentSummary({
    required this.department,
    required this.serviceCount,
  });

  /// The department offering the services.
  final Department department;

  /// The number of bookable services the department offers.
  final int serviceCount;
}
