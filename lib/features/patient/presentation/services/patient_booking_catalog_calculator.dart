import 'package:clinic_appointment_system/core/extensions/iterable_count_by.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_department_summary.dart';

/// Calculates departments that have at least one staff-bookable service.
final class PatientBookingCatalogCalculator {
  /// Creates a stateless booking catalog calculator.
  const PatientBookingCatalogCalculator();

  /// Returns bookable service counts in the catalog's Turkish name order.
  List<PatientDepartmentSummary> calculate(ClinicCatalog catalog) {
    final eligibleServiceIds = <String>{};
    for (final member in catalog.staff) {
      for (final serviceId in member.serviceIds) {
        final service = catalog.serviceById(serviceId);
        if (service != null && service.branchId == member.branchId) {
          eligibleServiceIds.add(serviceId);
        }
      }
    }
    final counts = catalog.services
        .where((service) => eligibleServiceIds.contains(service.id))
        .countBy((service) => service.departmentId);
    final summaries = <PatientDepartmentSummary>[];
    for (final department in catalog.departments) {
      final serviceCount = counts[department.id];
      if (serviceCount == null) continue;
      summaries.add(
        PatientDepartmentSummary(
          department: department,
          serviceCount: serviceCount,
        ),
      );
    }
    return List<PatientDepartmentSummary>.unmodifiable(summaries);
  }
}
