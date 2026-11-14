import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_department_summary.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Patient booking views derived from the shared clinic directory snapshot.
extension PatientCatalogViews on ClinicCatalog {
  /// Staff assigned to [service] who work in the service's branch.
  List<Staff> staffFor(MedicalService service) {
    return List<Staff>.unmodifiable(
      staff.where(
        (Staff member) =>
            member.branchId == service.branchId &&
            member.serviceIds.contains(service.id),
      ),
    );
  }

  /// Departments with at least one bookable service, sorted by Turkish name.
  /// A service is bookable when [staffFor] returns at least one member.
  List<PatientDepartmentSummary> get departmentsWithServiceCounts {
    final offered = <String, List<MedicalService>>{};
    for (final service in services) {
      if (staffFor(service).isNotEmpty) {
        offered.putIfAbsent(service.departmentId, () => []).add(service);
      }
    }
    final summaries = <PatientDepartmentSummary>[];
    for (final department in departments) {
      final items = offered[department.id];
      if (items != null) {
        summaries.add(
          PatientDepartmentSummary(
            department: department,
            serviceCount: items.length,
          ),
        );
      }
    }
    return List<PatientDepartmentSummary>.unmodifiable(summaries);
  }
}
