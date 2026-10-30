import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/fasting_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/service_duration.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/models/medical_service_form_values.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/widgets/lab_test_form_section.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/widgets/radiology_form_section.dart';
import 'package:flutter/widgets.dart';

/// Form strategy mapping medical service kinds to their polymorphic sub-sections and builders.
enum MedicalServiceFormKind {
  /// General doctor consultation without special parameters.
  examination(MedicalServiceKind.examination, SizedBox.shrink),

  /// Diagnostic imaging procedure with modality and preparation notes.
  radiology(MedicalServiceKind.radiology, RadiologyFormSection.new),

  /// Laboratory diagnostic test with fasting rules and turnaround time.
  lab(MedicalServiceKind.lab, LabTestFormSection.new);

  const MedicalServiceFormKind(this.kind, this.section);

  /// Domain kind associated with this form strategy.
  final MedicalServiceKind kind;

  /// Constructor tear-off building the kind-specific configuration section.
  final Widget Function({Key? key}) section;

  /// Resolves the form kind corresponding to the supplied domain [kind].
  static MedicalServiceFormKind of(MedicalServiceKind kind) {
    return switch (kind) {
      MedicalServiceKind.examination => MedicalServiceFormKind.examination,
      MedicalServiceKind.radiology => MedicalServiceFormKind.radiology,
      MedicalServiceKind.lab => MedicalServiceFormKind.lab,
    };
  }

  /// Builds the concrete [MedicalService] domain entity from raw [values].
  /// Text fields are normalized through [MedicalService.trimmed]. Throws `InstitutionException` for an invalid
  /// duration, fee or fasting window.
  MedicalService build(
    MedicalServiceFormValues values, {
    required String id,
    required String branchId,
  }) {
    final duration = ServiceDuration.parse(values.durationText);
    final fee = Money.parseLira(values.feeText);
    final MedicalService service = switch (this) {
      MedicalServiceFormKind.examination => Examination(
        id: id,
        name: values.name,
        departmentId: values.departmentId,
        branchId: branchId,
        duration: duration,
        fee: fee,
      ),
      MedicalServiceFormKind.radiology => RadiologyService(
        id: id,
        name: values.name,
        departmentId: values.departmentId,
        branchId: branchId,
        duration: duration,
        fee: fee,
        modality: values.modality,
        preparationNote: values.preparationNote,
      ),
      MedicalServiceFormKind.lab => LabTest(
        id: id,
        name: values.name,
        departmentId: values.departmentId,
        branchId: branchId,
        duration: duration,
        fee: fee,
        resultTime: values.resultTime,
        fastingHours: _fastingHours(values),
      ),
    };
    return service.trimmed();
  }

  /// The fasting window when fasting is required; typed text is ignored otherwise.
  FastingHours? _fastingHours(MedicalServiceFormValues values) {
    if (!values.requiresFasting) return null;
    return FastingHours.parse(values.fastingText);
  }
}
