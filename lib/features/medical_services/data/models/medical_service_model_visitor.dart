import 'package:clinic_appointment_system/features/medical_services/data/models/examination_model.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/lab_test_model.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/medical_service_model.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/radiology_service_model.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service_visitor.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';

/// Converts a domain medical service entity into its stored model counterpart.
final class MedicalServiceModelVisitor
    implements MedicalServiceVisitor<MedicalServiceModel> {
  /// Creates a visitor that converts entities into models.
  const MedicalServiceModelVisitor();

  @override
  MedicalServiceModel visitExamination(Examination service) {
    return ExaminationModel.fromEntity(service);
  }

  @override
  MedicalServiceModel visitRadiology(RadiologyService service) {
    return RadiologyServiceModel.fromEntity(service);
  }

  @override
  MedicalServiceModel visitLabTest(LabTest service) {
    return LabTestModel.fromEntity(service);
  }
}
