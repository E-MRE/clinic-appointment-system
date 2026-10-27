import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/errors/user_exception.dart';
import 'package:clinic_appointment_system/core/usecases/stream_use_case.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/user.dart';
import 'package:clinic_appointment_system/features/users/domain/repositories/user_repository.dart';

/// Observes the profile of a signed-in user.
final class WatchUserProfileUseCase
    implements StreamUseCase<DataResult<User>, String> {
  /// Injects the user profile boundary.
  const WatchUserProfileUseCase(this._users);

  final UserRepository _users;

  /// Watches the profile stored for the authentication [uid].
  /// Failures are emitted as [UserException] stream errors; setup failures can
  /// throw synchronously.
  @override
  Stream<DataResult<User>> call(String uid) => _users.watchUser(uid);
}
