import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/institution/data/converters/working_hours_converter.dart';
import 'package:clinic_appointment_system/features/institution/data/models/branch_model.dart';
import 'package:clinic_appointment_system/features/institution/data/repositories/firestore_institution_repository.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/branch_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/branch_repository.dart';

/// Persists branches in the `branches` Firestore collection.
final class FirestoreBranchRepository
    extends FirestoreInstitutionRepository<Branch, BranchDraft>
    implements BranchRepository {
  /// Injects the Firestore instance used to store branches.
  const FirestoreBranchRepository(super.firestore);

  @override
  String get collectionName => FirestoreConstants.branches;

  @override
  Branch entityFromJson(Map<String, dynamic> json) =>
      BranchModel.fromJson(json);

  @override
  Map<String, dynamic> fieldsFromDraft(BranchDraft draft) {
    return {
      FirestoreConstants.clinicId: draft.clinicId,
      FirestoreConstants.name: draft.name,
      FirestoreConstants.address: draft.address,
      FirestoreConstants.workingHours: const WorkingHoursConverter().toJson(
        draft.workingHours,
      ),
    };
  }

  @override
  Map<String, dynamic> fieldsFromEntity(Branch entity) {
    return BranchModel.fromEntity(entity).toJson();
  }

  @override
  Stream<DataResult<List<Branch>>> watchBranches(String clinicId) {
    return watchWhere(FirestoreConstants.clinicId, clinicId);
  }

  @override
  Future<DataResult<Branch>> createBranch(BranchDraft draft) {
    return createRecord(draft);
  }

  @override
  Future<DataResult<Branch>> updateBranch(Branch branch) {
    return updateRecord(branch);
  }
}
