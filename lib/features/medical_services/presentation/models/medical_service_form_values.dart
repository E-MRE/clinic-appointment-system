import 'package:clinic_appointment_system/features/medical_services/domain/enums/lab_result_time.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';

/// Immutable form state for creating and editing medical services.
final class MedicalServiceFormValues {
  /// Creates a form values model.
  const MedicalServiceFormValues({
    required this.kind,
    required this.name,
    required this.departmentId,
    required this.durationText,
    required this.feeText,
    this.modality = RadiologyModality.xRay,
    this.preparationNote = '',
    this.requiresFasting = false,
    this.fastingText = '',
    this.resultTime = LabResultTime.oneDay,
  });

  /// Empty default values starting with the examination kind.
  const MedicalServiceFormValues.empty()
    : kind = MedicalServiceKind.examination,
      name = '',
      departmentId = '',
      durationText = '',
      feeText = '',
      modality = RadiologyModality.xRay,
      preparationNote = '',
      requiresFasting = false,
      fastingText = '',
      resultTime = LabResultTime.oneDay;

  /// Kind of medical service being configured.
  final MedicalServiceKind kind;

  /// Display name of the medical service.
  final String name;

  /// Identifier of the assigned clinical department.
  final String departmentId;

  /// Raw input text representing service duration in minutes.
  final String durationText;

  /// Raw input text representing fee in Turkish Lira.
  final String feeText;

  /// Selected imaging modality for radiology procedures.
  final RadiologyModality modality;

  /// Preparation instructions shown to the patient for radiology services.
  final String preparationNote;

  /// Whether pre-procedure fasting is required for laboratory tests.
  final bool requiresFasting;

  /// Raw input text representing required fasting hours or range.
  final String fastingText;

  /// Turnaround time for laboratory test results.
  final LabResultTime resultTime;

  /// Returns a copy of these values with updated fields.
  MedicalServiceFormValues copyWith({
    MedicalServiceKind? kind,
    String? name,
    String? departmentId,
    String? durationText,
    String? feeText,
    RadiologyModality? modality,
    String? preparationNote,
    bool? requiresFasting,
    String? fastingText,
    LabResultTime? resultTime,
  }) {
    return MedicalServiceFormValues(
      kind: kind ?? this.kind,
      name: name ?? this.name,
      departmentId: departmentId ?? this.departmentId,
      durationText: durationText ?? this.durationText,
      feeText: feeText ?? this.feeText,
      modality: modality ?? this.modality,
      preparationNote: preparationNote ?? this.preparationNote,
      requiresFasting: requiresFasting ?? this.requiresFasting,
      fastingText: fastingText ?? this.fastingText,
      resultTime: resultTime ?? this.resultTime,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MedicalServiceFormValues &&
        other.kind == kind &&
        other.name == name &&
        other.departmentId == departmentId &&
        other.durationText == durationText &&
        other.feeText == feeText &&
        other.modality == modality &&
        other.preparationNote == preparationNote &&
        other.requiresFasting == requiresFasting &&
        other.fastingText == fastingText &&
        other.resultTime == resultTime;
  }

  @override
  int get hashCode {
    return Object.hash(
      kind,
      name,
      departmentId,
      durationText,
      feeText,
      modality,
      preparationNote,
      requiresFasting,
      fastingText,
      resultTime,
    );
  }
}
