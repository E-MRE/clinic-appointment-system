import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';

/// Inputs shared by every rule while validating one proposed window.
final class AvailabilityRuleContext {
  /// Creates an immutable validation snapshot.
  const AvailabilityRuleContext({
    required this.current,
    required this.branchHours,
    required this.today,
  });

  /// The schedule before the proposed window is added.
  final StaffAvailability current;

  /// The branch's current working hours.
  final WorkingHours branchHours;

  /// The current calendar date supplied by the caller's clock.
  final CalendarDate today;
}
