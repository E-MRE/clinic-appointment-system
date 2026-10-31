import 'package:clinic_appointment_system/core/enums/time_error_code.dart';
import 'package:clinic_appointment_system/core/errors/app_exception.dart';

/// A shared date or time validation failure.
final class TimeException extends AppException {
  /// Creates a time failure with its typed [code].
  const TimeException(this.code);

  /// The reason validation failed.
  final TimeErrorCode code;

  @override
  String toString() => 'TimeException: ${code.name}';
}
