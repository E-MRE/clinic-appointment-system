import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/department_repository.dart';

/// Observes department records across several branches.
final class WatchDepartmentsOfBranchesUseCase
    implements StreamUseCase<DataResult<List<Department>>, List<String>> {
  /// Injects the department persistence boundary.
  const WatchDepartmentsOfBranchesUseCase(this._repository);

  final DepartmentRepository _repository;

  /// Returns changes for the branch ids in [params].
  /// Repository failures are emitted as stream errors.
  @override
  Stream<DataResult<List<Department>>> call(List<String> params) {
    return _repository.watchDepartmentsOfBranches(params);
  }
}
