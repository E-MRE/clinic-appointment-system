import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/mixins/institution_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/department_repository.dart';

/// Validates and updates a department.
final class UpdateDepartmentUseCase
    with InstitutionInputValidationMixin
    implements UseCase<DataResult<Department>, Department> {
  /// Injects the department persistence boundary.
  const UpdateDepartmentUseCase(this._repository);

  final DepartmentRepository _repository;

  /// Updates the department with a trimmed name and returns the repository result.
  /// Throws [InstitutionException] if the name is blank or updating fails.
  @override
  Future<DataResult<Department>> call(Department department) async {
    ensureValid(nameError(department.name));
    final updatedDepartment = Department(
      id: department.id,
      branchId: department.branchId,
      name: department.name.trim(),
    );
    return _repository.updateDepartment(updatedDepartment);
  }
}
