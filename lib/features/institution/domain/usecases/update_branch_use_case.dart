import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/mixins/institution_input_validation_mixin.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/branch_repository.dart';

/// Validates and updates a branch.
final class UpdateBranchUseCase
    with InstitutionInputValidationMixin
    implements UseCase<DataResult<Branch>, Branch> {
  /// Injects the branch persistence boundary.
  const UpdateBranchUseCase(this._repository);

  final BranchRepository _repository;

  /// Updates the branch with trimmed name and address and returns the result.
  /// Throws [InstitutionException] if either required field is blank.
  @override
  Future<DataResult<Branch>> call(Branch branch) async {
    ensureValid(nameError(branch.name) ?? addressError(branch.address));
    final updatedBranch = Branch(
      id: branch.id,
      clinicId: branch.clinicId,
      name: branch.name.trim(),
      address: branch.address.trim(),
      workingHours: branch.workingHours,
    );
    return _repository.updateBranch(updatedBranch);
  }
}
