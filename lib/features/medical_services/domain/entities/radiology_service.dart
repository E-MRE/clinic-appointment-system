import 'package:clinic_appointment_system/core/constants/medical_service_constants.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service_visitor.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/radiology_modality.dart';

/// Diagnostic imaging medical service.
base class RadiologyService extends MedicalService {
  /// Creates a radiology imaging service.
  const RadiologyService({
    required super.id,
    required super.name,
    required super.departmentId,
    required super.branchId,
    required super.duration,
    required super.fee,
    required this.modality,
    this.preparationNote,
  });

  /// The medical imaging modality used for this procedure.
  final RadiologyModality modality;

  /// Optional pre-imaging preparation instructions for the patient.
  final String? preparationNote;

  @override
  MedicalServiceKind get kind => MedicalServiceKind.radiology;

  @override
  R accept<R>(MedicalServiceVisitor<R> visitor) => visitor.visitRadiology(this);

  @override
  RadiologyService trimmed() {
    final trimmedNote = preparationNote?.trim();
    final String? normalizedNote;
    if (trimmedNote == null || trimmedNote.isEmpty) {
      normalizedNote = null;
    } else {
      normalizedNote = trimmedNote;
    }

    return RadiologyService(
      id: id,
      name: name.trim(),
      departmentId: departmentId.trim(),
      branchId: branchId.trim(),
      duration: duration,
      fee: fee,
      modality: modality,
      preparationNote: normalizedNote,
    );
  }

  @override
  RadiologyService withId(String id) {
    return RadiologyService(
      id: id,
      name: name,
      departmentId: departmentId,
      branchId: branchId,
      duration: duration,
      fee: fee,
      modality: modality,
      preparationNote: preparationNote,
    );
  }

  @override
  InstitutionErrorCode? get detailsError {
    final note = preparationNote?.trim();
    if (note != null &&
        note.length > MedicalServiceConstants.maxPreparationNoteLength) {
      return InstitutionErrorCode.preparationNoteTooLong;
    }
    return null;
  }
}
