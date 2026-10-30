import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service_visitor.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/fasting_hours_formatting.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/money_formatting.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/medical_service_form_values.dart';

/// Pre-fills form values from an existing medical service via visitor pattern.
final class MedicalServiceFormValuesVisitor
    implements MedicalServiceVisitor<MedicalServiceFormValues> {
  /// Creates the form values visitor.
  const MedicalServiceFormValuesVisitor();

  @override
  MedicalServiceFormValues visitExamination(Examination service) {
    return MedicalServiceFormValues(
      kind: MedicalServiceKind.examination,
      name: service.name,
      departmentId: service.departmentId,
      durationText: '${service.duration.minutes}',
      feeText: service.fee.inputText,
    );
  }

  @override
  MedicalServiceFormValues visitRadiology(RadiologyService service) {
    return MedicalServiceFormValues(
      kind: MedicalServiceKind.radiology,
      name: service.name,
      departmentId: service.departmentId,
      durationText: '${service.duration.minutes}',
      feeText: service.fee.inputText,
      modality: service.modality,
      preparationNote: service.preparationNote ?? '',
    );
  }

  @override
  MedicalServiceFormValues visitLabTest(LabTest service) {
    return MedicalServiceFormValues(
      kind: MedicalServiceKind.lab,
      name: service.name,
      departmentId: service.departmentId,
      durationText: '${service.duration.minutes}',
      feeText: service.fee.inputText,
      requiresFasting: service.requiresFasting,
      fastingText: service.fastingHours?.inputText ?? '',
      resultTime: service.resultTime,
    );
  }
}
