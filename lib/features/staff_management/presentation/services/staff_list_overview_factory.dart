import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/staff_management/presentation/models/staff_list_overview.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Creates a clinic-scoped staff overview from the observed catalogue lists.
final class StaffListOverviewFactory {
  /// Creates an overview factory with no external dependencies.
  const StaffListOverviewFactory();

  /// Filters [branches] to [clinicId] and builds the overview from the lists.
  StaffListOverview create({
    required String? clinicId,
    required List<Staff> staff,
    required List<Branch> branches,
    required List<Department> departments,
    required List<MedicalService> services,
  }) {
    return StaffListOverview(
      staff: staff,
      branches: [
        if (clinicId != null)
          for (final branch in branches)
            if (branch.clinicId == clinicId) branch,
      ],
      departments: departments,
      services: services,
    );
  }
}
