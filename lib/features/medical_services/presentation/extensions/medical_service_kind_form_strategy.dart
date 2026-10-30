import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/strategies/examination_form_strategy.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/strategies/lab_test_form_strategy.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/strategies/medical_service_form_strategy.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/strategies/radiology_form_strategy.dart';

/// Picks the form strategy of a [MedicalServiceKind].
extension MedicalServiceKindFormStrategy on MedicalServiceKind {
  /// The form strategy that builds and configures this kind of service.
  MedicalServiceFormStrategy get formStrategy {
    return switch (this) {
      MedicalServiceKind.examination => const ExaminationFormStrategy(),
      MedicalServiceKind.radiology => const RadiologyFormStrategy(),
      MedicalServiceKind.lab => const LabTestFormStrategy(),
    };
  }
}
