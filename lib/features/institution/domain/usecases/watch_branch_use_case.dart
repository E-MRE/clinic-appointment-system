import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/branch_repository.dart';

/// Observes a branch by its identifier.
final class WatchBranchUseCase
    implements StreamUseCase<DataResult<Branch>, String> {
  /// Injects the branch persistence boundary.
  const WatchBranchUseCase(this._repository);

  final BranchRepository _repository;

  /// Returns branch changes for the identifier [params].
  /// Repository failures are emitted as stream errors.
  @override
  Stream<DataResult<Branch>> call(String params) {
    return _repository.watchBranch(params);
  }
}
