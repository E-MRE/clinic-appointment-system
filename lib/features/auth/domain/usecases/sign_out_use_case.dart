import 'package:clinic_appointment_system/core/errors/auth_exception.dart';
import 'package:clinic_appointment_system/core/errors/result.dart';
import 'package:clinic_appointment_system/core/usecases/no_params.dart';
import 'package:clinic_appointment_system/core/usecases/use_case.dart';
import 'package:clinic_appointment_system/features/auth/domain/repositories/auth_repository.dart';

/// Signs out the current user.
final class SignOutUseCase implements UseCase<Result, NoParams> {
  /// Injects the authentication boundary.
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  /// Returns a successful result once signed out.
  /// Throws [AuthException] if sign-out fails.
  @override
  Future<Result> call(NoParams params) => _repository.signOut();
}
