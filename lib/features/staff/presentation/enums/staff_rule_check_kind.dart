import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';

/// The four booking rules re-checked live for a staff appointment request,
/// in display order.
enum StaffRuleCheckKind {
  /// The slot lies inside one of the staff member's availability windows.
  withinAvailability(AppointmentErrorCode.outsideAvailability),

  /// The slot lies inside the branch working hours.
  withinWorkingHours(AppointmentErrorCode.outsideWorkingHours),

  /// No other approved appointment of the staff member overlaps the slot.
  noStaffOverlap(AppointmentErrorCode.staffOverlap),

  /// The staff member provides the requested service.
  staffProvidesService(AppointmentErrorCode.serviceNotProvided);

  const StaffRuleCheckKind(this.violationCode);

  /// The booking violation that fails this check.
  final AppointmentErrorCode violationCode;
}
