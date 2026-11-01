import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_booking_context.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_rule.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_violation.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/no_patient_overlap_rule.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/no_staff_overlap_rule.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/not_in_past_rule.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/staff_provides_service_rule.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/within_availability_rule.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/within_working_hours_rule.dart';

/// Runs independent booking rules and collects every violation.
final class AppointmentValidator {
  /// Creates a validator with the supplied rule sequence.
  const AppointmentValidator(this.rules);

  /// Creates the standard booking rule sequence.
  const AppointmentValidator.standard()
    : rules = const [
        NotInPastRule(),
        WithinWorkingHoursRule(),
        WithinAvailabilityRule(),
        StaffProvidesServiceRule(),
        NoStaffOverlapRule(),
        NoPatientOverlapRule(),
      ];

  /// Rules evaluated in order.
  final List<AppointmentRule> rules;

  /// Returns all violations in rule order, or an empty list.
  List<AppointmentViolation> validate(
    Appointment candidate,
    AppointmentBookingContext context,
  ) {
    final violations = <AppointmentViolation>[];
    for (final rule in rules) {
      final violation = rule.check(candidate, context);
      if (violation != null) violations.add(violation);
    }
    return violations;
  }
}
