import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/repositories/medical_service_repository.dart';

/// Observes medical service records across several branches.
final class WatchServicesOfBranchesUseCase
    implements StreamUseCase<DataResult<List<MedicalService>>, List<String>> {
  /// Injects the medical service persistence boundary.
  const WatchServicesOfBranchesUseCase(this._repository);

  final MedicalServiceRepository _repository;

  /// Returns changes for the branch ids in [params].
  /// Repository failures are emitted as stream errors.
  @override
  Stream<DataResult<List<MedicalService>>> call(List<String> params) {
    return _repository.watchServicesOfBranches(params);
  }
}
