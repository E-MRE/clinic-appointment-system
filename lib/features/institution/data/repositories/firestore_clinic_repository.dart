import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/institution/data/models/clinic_model.dart';
import 'package:clinic_appointment_system/features/institution/data/repositories/firestore_institution_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/clinic_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/clinic_repository.dart';

/// Persists clinics in the `clinics` Firestore collection.
final class FirestoreClinicRepository
    extends FirestoreInstitutionRepository<Clinic, ClinicDraft>
    implements ClinicRepository {
  /// Injects the Firestore instance used to store clinics.
  const FirestoreClinicRepository(super.firestore);

  @override
  String get collectionName => FirestoreConstants.clinics;

  @override
  Clinic entityFromJson(Map<String, dynamic> json) =>
      ClinicModel.fromJson(json);

  @override
  Map<String, dynamic> fieldsFromDraft(ClinicDraft draft) {
    return {FirestoreConstants.name: draft.name};
  }

  @override
  Map<String, dynamic> fieldsFromEntity(Clinic entity) {
    return ClinicModel.fromEntity(entity).toJson();
  }

  @override
  Stream<DataResult<List<Clinic>>> watchClinics() => watchAll();

  @override
  Future<DataResult<Clinic>> createClinic(ClinicDraft draft) {
    return createRecord(draft);
  }

  @override
  Future<DataResult<Clinic>> updateClinic(Clinic clinic) {
    return updateRecord(clinic);
  }
}
