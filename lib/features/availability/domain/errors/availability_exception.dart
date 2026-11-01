import 'package:clinic_appointment_system/core/errors/app_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/enums/availability_error_code.dart';

/// An availability failure independent of the storage provider.
final class AvailabilityException extends AppException {
  /// Creates a failure; [conflict] is supplied only for overlapping windows.
  const AvailabilityException(this.code, {this.conflict});

  /// The machine-readable cause of the failure.
  final AvailabilityErrorCode code;

  /// The existing window responsible for an overlapping-window failure.
  final AvailabilityWindow? conflict;

  /// Describes the failure without user-facing text.
  @override
  String toString() => 'AvailabilityException: ${code.name}';
}
