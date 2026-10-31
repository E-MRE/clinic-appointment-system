import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service_visitor.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';

/// Resolves the service kinds a technician may provide.
final class TechnicianServiceEligibility
    implements MedicalServiceVisitor<bool> {
  /// Creates the stateless role eligibility visitor.
  const TechnicianServiceEligibility();

  @override
  bool visitExamination(Examination service) => false;

  @override
  bool visitRadiology(RadiologyService service) => true;

  @override
  bool visitLabTest(LabTest service) => true;
}
