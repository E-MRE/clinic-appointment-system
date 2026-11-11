import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:equatable/equatable.dart';

/// An immutable bundle of workplace context for the signed-in staff member.
///
/// Combines the staff profile, availability schedule, assigned branch and
/// department, and the medical services offered by the branch.
final class StaffWorkspace extends Equatable {
  /// Creates a staff workspace snapshot and indexes its services by id.
  StaffWorkspace({
    required this.staff,
    required this.availability,
    required this.branch,
    required this.department,
    required List<MedicalService> services,
  }) : services = List<MedicalService>.unmodifiable(services),
       _servicesById = {for (final service in services) service.id: service};

  /// The signed-in staff profile.
  final Staff staff;

  /// The staff member's availability schedule at the assigned branch.
  final StaffAvailability availability;

  /// The staff member's branch, including name and working hours.
  final Branch branch;

  /// The staff member's assigned department.
  final Department department;

  /// Medical services offered by the branch.
  final List<MedicalService> services;

  final Map<String, MedicalService> _servicesById;

  /// Finds a medical service by its [id], or null when not offered.
  MedicalService? serviceById(String id) => _servicesById[id];

  @override
  List<Object?> get props => [
    staff,
    availability,
    branch,
    department,
    services,
  ];
}
