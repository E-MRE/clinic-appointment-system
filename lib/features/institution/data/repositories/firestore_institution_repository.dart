import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/institution_record.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Shares Firestore query, sorting, persistence, and error behavior for
/// institution records. Concrete repositories provide their collection and
/// conversions while this base class owns the persistence algorithm.
abstract base class FirestoreInstitutionRepository<
  Entity extends InstitutionRecord,
  Draft
> {
  /// Injects the Firestore instance used by the repository.
  const FirestoreInstitutionRepository(this.firestore);

  /// The injected Firestore instance shared by this repository algorithm.
  final FirebaseFirestore firestore;

  /// The Firestore collection used by this institution repository.
  String get collectionName;

  /// Parses stored fields and the Firestore document id into an entity.
  Entity entityFromJson(Map<String, dynamic> json);

  /// Converts a creation draft to the exact stored fields for its entity.
  Map<String, dynamic> fieldsFromDraft(Draft draft);

  /// Converts an existing entity to the exact fields written on update.
  Map<String, dynamic> fieldsFromEntity(Entity entity);

  /// Watches every record in this collection, sorted by its display name.
  /// Firestore errors are emitted as [InstitutionException].
  Stream<DataResult<List<Entity>>> watchAll() {
    return _watchQuery(firestore.collection(collectionName));
  }

  /// Watches records whose [field] equals [value], sorted by display name.
  /// Firestore errors are emitted as [InstitutionException].
  Stream<DataResult<List<Entity>>> watchWhere(String field, String value) {
    final query = firestore
        .collection(collectionName)
        .where(field, isEqualTo: value);
    return _watchQuery(query);
  }

  /// Watches records whose [field] is in [values], sorted by display name.
  /// An empty list emits one successful empty result without querying.
  /// Lists over [FirestoreConstants.maxWhereInValues] emit unavailable;
  /// provider and parsing errors follow the same rules as [watchWhere].
  Stream<DataResult<List<Entity>>> watchWhereIn(
    String field,
    List<String> values,
  ) {
    if (values.isEmpty) {
      return Stream.value(const DataResult.success(data: []));
    }
    if (values.length > FirestoreConstants.maxWhereInValues) {
      return Stream.error(
        const InstitutionException(InstitutionErrorCode.unavailable),
      );
    }
    final Query<Map<String, dynamic>> query = firestore
        .collection(collectionName)
        .where(field, whereIn: values);
    return _watchQuery(query);
  }

  /// Adds [draft] and returns the entity with its generated document id.
  Future<DataResult<Entity>> createRecord(Draft draft) async {
    try {
      final fields = fieldsFromDraft(draft);
      final document = await firestore.collection(collectionName).add(fields);
      return DataResult.success(
        data: entityFromJson({...fields, 'id': document.id}),
      );
    } on FirebaseException catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const InstitutionException(InstitutionErrorCode.unavailable),
        stackTrace,
      );
    }
  }

  /// Updates [entity] and returns it; a missing document is a Firestore error.
  Future<DataResult<Entity>> updateRecord(Entity entity) async {
    try {
      await firestore
          .collection(collectionName)
          .doc(entity.id)
          .update(fieldsFromEntity(entity));
      return DataResult.success(data: entity);
    } on FirebaseException catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const InstitutionException(InstitutionErrorCode.unavailable),
        stackTrace,
      );
    }
  }

  Stream<DataResult<List<Entity>>> _watchQuery(
    Query<Map<String, dynamic>> query,
  ) {
    return query.snapshots().handleError(_handleStreamError).map(_toRecords);
  }

  DataResult<List<Entity>> _toRecords(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    try {
      final entities = snapshot.docs.map((document) {
        return entityFromJson({...document.data(), 'id': document.id});
      }).toList()..sort((first, second) => first.name.compareTo(second.name));
      return DataResult.success(data: entities);
    } on CheckedFromJsonException catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const InstitutionException(InstitutionErrorCode.invalidRecord),
        stackTrace,
      );
    } on TypeError catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const InstitutionException(InstitutionErrorCode.invalidRecord),
        stackTrace,
      );
    } on ArgumentError catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const InstitutionException(InstitutionErrorCode.invalidRecord),
        stackTrace,
      );
    } on FormatException catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const InstitutionException(InstitutionErrorCode.invalidRecord),
        stackTrace,
      );
    } on InstitutionException catch (_, stackTrace) {
      Error.throwWithStackTrace(
        const InstitutionException(InstitutionErrorCode.invalidRecord),
        stackTrace,
      );
    }
  }

  void _handleStreamError(Object error, StackTrace stackTrace) {
    if (error is FirebaseException) {
      Error.throwWithStackTrace(
        const InstitutionException(InstitutionErrorCode.unavailable),
        stackTrace,
      );
    }
    Error.throwWithStackTrace(error, stackTrace);
  }
}
