import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/mixins/institution_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/branch_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/branch_repository.dart';

/// Validates and creates a branch.
final class CreateBranchUseCase
    with InstitutionInputValidationMixin
    implements UseCase<DataResult<Branch>, BranchDraft> {
  /// Injects the branch persistence boundary.
  const CreateBranchUseCase(this._repository);

  final BranchRepository _repository;

  /// Creates the branch with trimmed name and address and returns the result.
  /// Throws [InstitutionException] if either required field is blank.
  @override
  Future<DataResult<Branch>> call(BranchDraft draft) async {
    ensureValid(nameError(draft.name) ?? addressError(draft.address));
    return _repository.createBranch(draft.trimmed());
  }
}
