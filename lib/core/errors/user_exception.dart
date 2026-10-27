import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_error_code.dart';

/// A profile failure identified independently of its storage provider.
final class UserException extends AppException {
  /// Creates a profile failure with its typed code.
  const UserException(this.code);

  /// The reason the profile operation failed.
  final UserErrorCode code;

  @override
  String toString() => 'UserException: ${code.name}';
}
