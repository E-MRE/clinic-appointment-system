import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/entities/auth_session.dart';
import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';

/// Observes the restored session and later sign-in and sign-out changes.
final class WatchSessionUseCase
    implements StreamUseCase<DataResult<AuthSession>, NoParams> {
  /// Injects the authentication boundary.
  const WatchSessionUseCase(this._repository);

  final AuthRepository _repository;

  /// A successful result with null data means signed out.
  /// Failures are emitted as [AuthException] stream errors; setup failures can
  /// throw synchronously.
  @override
  Stream<DataResult<AuthSession>> call(NoParams params) {
    return _repository.authStateChanges();
  }
}
