import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/department_draft.dart';

/// Department persistence boundary. Success uses results; failures throw
/// [InstitutionException].
abstract interface class DepartmentRepository {
  /// Watches the departments owned by [branchId].
  /// Stream errors are emitted as [InstitutionException].
  Stream<DataResult<List<Department>>> watchDepartments(String branchId);

  /// Creates a department from [draft].
  /// Throws [InstitutionException] if creation fails.
  Future<DataResult<Department>> createDepartment(DepartmentDraft draft);

  /// Saves the changed values of [department].
  /// Throws [InstitutionException] if updating fails.
  Future<DataResult<Department>> updateDepartment(Department department);
}
