import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/enums/medical_service_kind_filter.dart';

/// Matches and counts services against a [MedicalServiceKindFilter].
extension MedicalServiceKindFilterMatching on MedicalServiceKindFilter {
  /// Whether [service] belongs to this filter category.
  bool matches(MedicalService service) => kind == null || service.kind == kind;

  /// Counts the services matching this filter in [services].
  int countIn(List<MedicalService> services) => services.where(matches).length;
}
