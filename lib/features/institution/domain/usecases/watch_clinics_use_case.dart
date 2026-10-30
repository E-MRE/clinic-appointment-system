import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:clinic_appointment_system/features/institution/domain/entities/clinic.dart';
import 'package:clinic_appointment_system/features/institution/domain/repositories/clinic_repository.dart';

/// Observes the clinic collection.
final class WatchClinicsUseCase
    implements StreamUseCase<DataResult<List<Clinic>>, NoParams> {
  /// Injects the clinic persistence boundary.
  const WatchClinicsUseCase(this._repository);

  final ClinicRepository _repository;

  /// Returns clinic changes; repository failures are emitted as stream errors.
  @override
  Stream<DataResult<List<Clinic>>> call(NoParams params) {
    return _repository.watchClinics();
  }
}
