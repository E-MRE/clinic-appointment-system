import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/institution/data/models/department_model.dart';
import 'package:clinic_appointment_system/features/institution/data/repositories/firestore_institution_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/department_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/department_repository.dart';

/// Persists departments in the `departments` Firestore collection.
final class FirestoreDepartmentRepository
    extends FirestoreInstitutionRepository<Department, DepartmentDraft>
    implements DepartmentRepository {
  /// Injects the Firestore instance used to store departments.
  const FirestoreDepartmentRepository(super.firestore);

  @override
  String get collectionName => FirestoreConstants.departments;

  @override
  Department entityFromJson(Map<String, dynamic> json) =>
      DepartmentModel.fromJson(json);

  @override
  Map<String, dynamic> fieldsFromDraft(DepartmentDraft draft) {
    return {
      FirestoreConstants.branchId: draft.branchId,
      FirestoreConstants.name: draft.name,
    };
  }

  @override
  Map<String, dynamic> fieldsFromEntity(Department entity) {
    return DepartmentModel.fromEntity(entity).toJson();
  }

  @override
  @override
  Stream<DataResult<List<Department>>> watchDepartments(String branchId) {
    return watchWhere(FirestoreConstants.branchId, branchId);
  }

  @override
  Future<DataResult<Department>> createDepartment(DepartmentDraft draft) {
    return createRecord(draft);
  }

  @override
  Future<DataResult<Department>> updateDepartment(Department department) {
    return updateRecord(department);
  }
}
