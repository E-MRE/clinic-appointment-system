import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service_visitor.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';

/// Resolves the service kinds a doctor may provide.
final class DoctorServiceEligibility implements MedicalServiceVisitor<bool> {
  /// Creates the stateless role eligibility visitor.
  const DoctorServiceEligibility();

  @override
  bool visitExamination(Examination service) => true;

  @override
  bool visitRadiology(RadiologyService service) => false;

  @override
  bool visitLabTest(LabTest service) => false;
}
