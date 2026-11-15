import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:equatable/equatable.dart';

/// Stores precomputed medical service counts and department lookups.
final class MedicalServiceListOverview extends Equatable {
  /// Creates an overview from already-calculated values.
  const MedicalServiceListOverview({
    required this.total,
    required this.examinationCount,
    required this.radiologyCount,
    required this.labCount,
    required this.distinctDepartmentsCount,
    required this.departmentMap,
  });

  /// Total count of all loaded services.
  final int total;

  /// Total count of examination services.
  final int examinationCount;

  /// Total count of radiology imaging services.
  final int radiologyCount;

  /// Total count of laboratory test services.
  final int labCount;

  /// Number of distinct departments referenced by the loaded services.
  final int distinctDepartmentsCount;

  /// Lookup map by department id.
  final Map<String, Department> departmentMap;

  @override
  List<Object?> get props => [
    total,
    examinationCount,
    radiologyCount,
    labCount,
    distinctDepartmentsCount,
    departmentMap,
  ];
}
