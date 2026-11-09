import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule.dart';

/// The closed set of states of a staff member's observed booking week.
sealed class StaffWeekScheduleState {
  /// Creates a schedule state.
  const StaffWeekScheduleState();
}

/// No staff member is chosen, so nothing is observed.
final class StaffWeekScheduleIdle extends StaffWeekScheduleState {
  /// Creates the idle state.
  const StaffWeekScheduleIdle();
}

/// Waiting for the availability and every listed day's booked slots.
final class StaffWeekScheduleLoading extends StaffWeekScheduleState {
  /// Creates the loading state.
  const StaffWeekScheduleLoading();
}

/// The availability or a day's booked slots could not be observed.
final class StaffWeekScheduleFailure extends StaffWeekScheduleState {
  /// Creates the failure state.
  const StaffWeekScheduleFailure();
}

/// Every source arrived; [schedule] is their latest combination.
final class StaffWeekScheduleLoaded extends StaffWeekScheduleState {
  /// Creates the loaded state holding [schedule].
  const StaffWeekScheduleLoaded(this.schedule);

  /// The latest week schedule.
  final StaffWeekSchedule schedule;
}
