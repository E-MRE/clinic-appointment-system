import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/department_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/department_repository.dart';

final class FakeDepartmentRepository implements DepartmentRepository {
  Stream<DataResult<List<Department>>> departmentsStream = const Stream.empty();
  DataResult<Department> createResult = const DataResult.error();
  DataResult<Department> updateResult = const DataResult.error();
  DepartmentDraft? createdDraft;
  Department? updatedDepartment;
  String? watchedBranchId;
  List<String>? watchedBranchIds;
  int createCalls = 0;
  int updateCalls = 0;

  @override
  Stream<DataResult<List<Department>>> watchDepartments(String branchId) {
    watchedBranchId = branchId;
    return departmentsStream;
  }

  @override
  Stream<DataResult<List<Department>>> watchDepartmentsOfBranches(
    List<String> branchIds,
  ) {
    watchedBranchIds = branchIds;
    return departmentsStream;
  }

  @override
  Future<DataResult<Department>> createDepartment(DepartmentDraft draft) async {
    createCalls++;
    createdDraft = draft;
    return createResult;
  }

  @override
  Future<DataResult<Department>> updateDepartment(Department department) async {
    updateCalls++;
    updatedDepartment = department;
    return updateResult;
  }
}
