import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/models/branch_draft.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/create_branch_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/usecases/update_branch_use_case.dart';
import 'package:clinic_appointment_system/features/institution/presentation/cubit/institution_save_cubit.dart';

/// Creates and updates branches for the institution screens.
final class BranchSaveCubit extends InstitutionSaveCubit<Branch> {
  /// Injects both branch operations used by this request cubit.
  BranchSaveCubit(this._createBranch, this._updateBranch);

  final CreateBranchUseCase _createBranch;
  final UpdateBranchUseCase _updateBranch;

  /// Creates a branch from [draft].
  Future<void> create(BranchDraft draft) =>
      executeRequest(() => _createBranch(draft));

  /// Updates [branch] using its current values.
  Future<void> update(Branch branch) =>
      executeRequest(() => _updateBranch(branch));
}
