import 'package:clinic_appointment_system/features/availability/domain/entities/staff_availability.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_schedule_day.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule_request.dart';

/// The requested week and its generated days for one staff member.
final class StaffWeekSchedule {
  /// Creates a schedule from already-generated [days].
  const StaffWeekSchedule({
    required this.request,
    required this.availability,
    required this.days,
  });

  /// The staff member, service, week and branch hours this schedule shows.
  final StaffWeekScheduleRequest request;

  /// The staff member's availability the slots were generated from.
  final StaffAvailability availability;

  /// The listed days in date order.
  final List<StaffScheduleDay> days;
}
