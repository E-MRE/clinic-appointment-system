import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/examination_model.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/lab_test_model.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/medical_service_model.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/medical_service_model_visitor.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/radiology_service_model.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';

/// Builds the medical service model that matches a stored document's kind.
final class MedicalServiceModelFactory {
  /// Creates the medical service model factory.
  const MedicalServiceModelFactory();

  /// Converts a domain [service] into its stored model representation.
  MedicalServiceModel toModel(MedicalService service) {
    return service.accept(const MedicalServiceModelVisitor());
  }

  /// Creates the model for the kind stored in [json].
  ///
  /// Throws [ArgumentError] for an unknown kind, [TypeError] for a missing
  /// or non-string one, and `CheckedFromJsonException` or [FormatException]
  /// for missing or malformed fields.
  MedicalServiceModel fromJson(Map<String, dynamic> json) {
    final kind = MedicalServiceKind.values.byName(
      json[FirestoreConstants.kind] as String,
    );
    return switch (kind) {
      MedicalServiceKind.examination => ExaminationModel.fromJson(json),
      MedicalServiceKind.radiology => RadiologyServiceModel.fromJson(json),
      MedicalServiceKind.lab => LabTestModel.fromJson(json),
    };
  }
}
