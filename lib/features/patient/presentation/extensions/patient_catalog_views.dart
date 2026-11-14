import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
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
}
