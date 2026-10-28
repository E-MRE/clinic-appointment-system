import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/department_repository.dart';

/// Observes departments belonging to a branch.
final class WatchDepartmentsUseCase
    implements StreamUseCase<DataResult<List<Department>>, String> {
  /// Injects the department persistence boundary.
  const WatchDepartmentsUseCase(this._repository);

  final DepartmentRepository _repository;

  /// Returns department changes for the branch [params].
  /// Repository failures are emitted as stream errors.
  @override
  Stream<DataResult<List<Department>>> call(String params) {
    return _repository.watchDepartments(params);
  }
}
