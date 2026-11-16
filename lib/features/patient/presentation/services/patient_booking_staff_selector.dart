import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// Selects staff members who can provide a service at its assigned branch.
final class PatientBookingStaffSelector {
  /// Creates a stateless booking staff selector.
  const PatientBookingStaffSelector();

  /// Returns the catalog staff assigned to [service] in its branch order.
  List<Staff> select({
    required ClinicCatalog catalog,
    required MedicalService service,
  }) {
    return List<Staff>.unmodifiable(
      catalog.staff.where(
        (Staff member) =>
            member.branchId == service.branchId &&
            member.serviceIds.contains(service.id),
      ),
    );
  }
}
