import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/branch_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/branch_repository.dart';

final class FakeBranchRepository implements BranchRepository {
  Stream<DataResult<Branch>> branchStream = const Stream.empty();
  String? watchedBranchId;
  Stream<DataResult<List<Branch>>> branchesStream = const Stream.empty();
  DataResult<Branch> createResult = const DataResult.error();
  DataResult<Branch> updateResult = const DataResult.error();
  BranchDraft? createdDraft;
  Branch? updatedBranch;
  String? watchedClinicId;
  int createCalls = 0;
  int updateCalls = 0;

  @override
  Stream<DataResult<Branch>> watchBranch(String branchId) {
    watchedBranchId = branchId;
    return branchStream;
  }

  @override
  Stream<DataResult<List<Branch>>> watchBranches(String clinicId) {
    watchedClinicId = clinicId;
    return branchesStream;
  }

  @override
  Future<DataResult<Branch>> createBranch(BranchDraft draft) async {
    createCalls++;
    createdDraft = draft;
    return createResult;
  }

  @override
  Future<DataResult<Branch>> updateBranch(Branch branch) async {
    updateCalls++;
    updatedBranch = branch;
    return updateResult;
  }
}
