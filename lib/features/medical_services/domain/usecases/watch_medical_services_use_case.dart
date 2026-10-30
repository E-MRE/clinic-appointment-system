import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/repositories/medical_service_repository.dart';

/// Observes medical services belonging to a branch.
final class WatchMedicalServicesUseCase
    implements StreamUseCase<DataResult<List<MedicalService>>, String> {
  /// Injects the medical service persistence boundary.
  const WatchMedicalServicesUseCase(this._repository);

  final MedicalServiceRepository _repository;

  /// Returns medical service changes for the branch [params].
  /// Repository failures are emitted as stream errors.
  @override
  Stream<DataResult<List<MedicalService>>> call(String params) {
    return _repository.watchServices(params);
  }
}
