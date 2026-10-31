import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/branch_draft.dart';

/// Branch persistence boundary. Success uses results; failures throw
/// [InstitutionException].
abstract interface class BranchRepository {
  /// Watches the branch identified by [branchId].
  /// Missing records and provider failures are [InstitutionException] stream errors.
  Stream<DataResult<Branch>> watchBranch(String branchId);

  /// Watches the branches owned by [clinicId].
  /// Stream errors are emitted as [InstitutionException].
  Stream<DataResult<List<Branch>>> watchBranches(String clinicId);

  /// Creates a branch from [draft].
  /// Throws [InstitutionException] if creation fails.
  Future<DataResult<Branch>> createBranch(BranchDraft draft);

  /// Saves the changed values of [branch].
  /// Throws [InstitutionException] if updating fails.
  Future<DataResult<Branch>> updateBranch(Branch branch);
}
