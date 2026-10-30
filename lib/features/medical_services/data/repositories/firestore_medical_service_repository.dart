import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/institution/data/repositories/firestore_institution_repository.dart';
import 'package:clinic_appointment_system/features/medical_services/data/models/medical_service_model_factory.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/repositories/medical_service_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Persists medical services in the `services` Firestore collection.
final class FirestoreMedicalServiceRepository
    extends FirestoreInstitutionRepository<MedicalService, MedicalService>
    implements MedicalServiceRepository {
  /// Injects the Firestore instance and model factory used to persist services.
  const FirestoreMedicalServiceRepository(super.firestore, this.factory);

  /// Factory responsible for converting between stored documents and models.
  final MedicalServiceModelFactory factory;

  @override
  String get collectionName => FirestoreConstants.services;

  @override
  MedicalService entityFromJson(Map<String, dynamic> json) =>
      factory.fromJson(json);

  @override
  Map<String, dynamic> fieldsFromDraft(MedicalService draft) =>
      factory.toModel(draft).toJson();

  /// Optional keys a model omits when empty. An update merges fields, so an
  /// omitted key is deleted explicitly; otherwise a cleared preparation note
  /// or fasting window would survive in the stored document.
  List<String> get _optionalKeys => [
    FirestoreConstants.preparationNote,
    FirestoreConstants.fastingHours,
  ];

  @override
  Map<String, dynamic> fieldsFromEntity(MedicalService entity) {
    final fields = factory.toModel(entity).toJson();
    for (final key in _optionalKeys) {
      fields.putIfAbsent(key, FieldValue.delete);
    }
    return fields;
  }

  @override
  Stream<DataResult<List<MedicalService>>> watchServices(String branchId) {
    return watchWhere(FirestoreConstants.branchId, branchId);
  }

  @override
  Future<DataResult<MedicalService>> createService(MedicalService service) {
    return createRecord(service);
  }

  @override
  Future<DataResult<MedicalService>> updateService(MedicalService service) {
    return updateRecord(service);
  }
}
