import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/department.dart';
import 'package:clinic_appointment_system/features/institution/domain/mixins/institution_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/department_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/department_repository.dart';

/// Validates and creates a department.
final class CreateDepartmentUseCase
    with InstitutionInputValidationMixin
    implements UseCase<DataResult<Department>, DepartmentDraft> {
  /// Injects the department persistence boundary.
  const CreateDepartmentUseCase(this._repository);

  final DepartmentRepository _repository;

  /// Creates the department with a trimmed name and returns the repository result.
  /// Throws [InstitutionException] if the name is blank or creation fails.
  @override
  Future<DataResult<Department>> call(DepartmentDraft draft) async {
    ensureValid(nameError(draft.name));
    return _repository.createDepartment(draft.trimmed());
  }
}
