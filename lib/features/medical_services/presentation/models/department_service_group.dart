import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:equatable/equatable.dart';

/// Group of medical services belonging to a department on mobile views.
final class DepartmentServiceGroup extends Equatable {
  /// Creates a department-service group; null names represent unknown departments.
  const DepartmentServiceGroup({
    required this.departmentName,
    required this.services,
  });

  /// Department name, or null for services with an unknown department.
  final String? departmentName;

  /// Ordered medical services within this department group.
  final List<MedicalService> services;

  /// Groups are identified by their department name alone.
  @override
  List<Object?> get props => [departmentName];

  @override
  String toString() =>
      'DepartmentServiceGroup(departmentName: $departmentName, count: ${services.length})';
}
