import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service_visitor.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';

final class RecordingMedicalServiceVisitor
    implements MedicalServiceVisitor<String> {
  Examination? visitedExamination;
  RadiologyService? visitedRadiology;
  LabTest? visitedLabTest;

  @override
  String visitExamination(Examination service) {
    visitedExamination = service;
    return 'examination:${service.name}';
  }

  @override
  String visitRadiology(RadiologyService service) {
    visitedRadiology = service;
    return 'radiology:${service.name}';
  }

  @override
  String visitLabTest(LabTest service) {
    visitedLabTest = service;
    return 'lab:${service.name}';
  }
}
