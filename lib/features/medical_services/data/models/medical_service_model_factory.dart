import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/examination_model.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/lab_test_model.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/medical_service_model.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/radiology_service_model.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/examination.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/lab_test.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service_visitor.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/radiology_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/enums/medical_service_kind.dart';

/// Builds the medical service model that matches a stored document's kind,
/// or a domain service's concrete type.
final class MedicalServiceModelFactory
    implements MedicalServiceVisitor<MedicalServiceModel> {
  /// Creates the medical service model factory.
  const MedicalServiceModelFactory();

  /// Converts a domain [service] into its stored model representation.
  MedicalServiceModel toModel(MedicalService service) => service.accept(this);

  /// Creates the model for the kind stored in [json].
  ///
  /// Throws [ArgumentError] for an unknown kind, [TypeError] for a missing
  /// or non-string one, and `CheckedFromJsonException` for missing or
  /// malformed fields.
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
