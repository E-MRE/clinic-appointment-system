import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';

/// Visitor contract for polymorphic operations across medical service types.
abstract interface class MedicalServiceVisitor<R> {
  /// Visits a standard consultation [service].
  R visitExamination(Examination service);

  /// Visits a radiology imaging [service].
  R visitRadiology(RadiologyService service);

  /// Visits a laboratory diagnostic [service].
  R visitLabTest(LabTest service);
}
