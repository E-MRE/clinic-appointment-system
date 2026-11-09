import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';

/// Reads an appointment failure from a result whose code is typed as [Enum].
extension DataResultAppointmentErrorCode<T> on DataResult<T> {
  /// The carried [AppointmentErrorCode], or
  /// [AppointmentErrorCode.unavailable] when the code is missing or foreign.
  AppointmentErrorCode get appointmentErrorCode {
    return switch (errorCode) {
      final AppointmentErrorCode code => code,
      _ => AppointmentErrorCode.unavailable,
    };
  }
}
