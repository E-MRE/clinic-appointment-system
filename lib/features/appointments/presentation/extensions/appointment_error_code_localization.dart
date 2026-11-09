import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';

/// Localized appointment failures; the single place turning a code into text.
extension AppointmentErrorCodeLocalization on AppointmentErrorCode {
  /// The localized message for this failure.
  String get message {
    return switch (this) {
      AppointmentErrorCode.unavailable =>
        LocaleKeys.appointment_errors_unavailable,
      AppointmentErrorCode.invalidRecord =>
        LocaleKeys.appointment_errors_invalidRecord,
      AppointmentErrorCode.notFound => LocaleKeys.appointment_errors_notFound,
      AppointmentErrorCode.invalidTransition =>
        LocaleKeys.appointment_errors_invalidTransition,
      AppointmentErrorCode.notPermitted =>
        LocaleKeys.appointment_errors_notPermitted,
      AppointmentErrorCode.tooEarly => LocaleKeys.appointment_errors_tooEarly,
      AppointmentErrorCode.tooLate => LocaleKeys.appointment_errors_tooLate,
      AppointmentErrorCode.invalidHistory =>
        LocaleKeys.appointment_errors_invalidHistory,
      AppointmentErrorCode.inPast => LocaleKeys.appointment_errors_inPast,
      AppointmentErrorCode.outsideWorkingHours =>
        LocaleKeys.appointment_errors_outsideWorkingHours,
      AppointmentErrorCode.outsideAvailability =>
        LocaleKeys.appointment_errors_outsideAvailability,
      AppointmentErrorCode.serviceNotProvided =>
        LocaleKeys.appointment_errors_serviceNotProvided,
      AppointmentErrorCode.staffOverlap =>
        LocaleKeys.appointment_errors_staffOverlap,
      AppointmentErrorCode.patientOverlap =>
        LocaleKeys.appointment_errors_patientOverlap,
    }.translate();
  }
}
