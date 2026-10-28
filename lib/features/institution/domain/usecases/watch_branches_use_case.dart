import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/branch.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/branch_repository.dart';

/// Observes branches belonging to a clinic.
final class WatchBranchesUseCase
    implements StreamUseCase<DataResult<List<Branch>>, String> {
  /// Injects the branch persistence boundary.
  const WatchBranchesUseCase(this._repository);

  final BranchRepository _repository;

  /// Returns branch changes for the clinic [params].
  /// Repository failures are emitted as stream errors.
  @override
  Stream<DataResult<List<Branch>>> call(String params) {
    return _repository.watchBranches(params);
  }
}
