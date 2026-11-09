import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';

/// How the booking page reacts to an [AppointmentErrorCode].
extension AppointmentErrorCodeBooking on AppointmentErrorCode {
  /// Whether another appointment took the slot, so the choice is cleared.
  bool get clearsSlot {
    return switch (this) {
      AppointmentErrorCode.staffOverlap ||
      AppointmentErrorCode.patientOverlap => true,
      AppointmentErrorCode.unavailable ||
      AppointmentErrorCode.invalidRecord ||
      AppointmentErrorCode.notFound ||
      AppointmentErrorCode.invalidTransition ||
      AppointmentErrorCode.notPermitted ||
      AppointmentErrorCode.tooEarly ||
      AppointmentErrorCode.tooLate ||
      AppointmentErrorCode.invalidHistory ||
      AppointmentErrorCode.inPast ||
      AppointmentErrorCode.outsideWorkingHours ||
      AppointmentErrorCode.outsideAvailability ||
      AppointmentErrorCode.serviceNotProvided => false,
    };
  }
}
