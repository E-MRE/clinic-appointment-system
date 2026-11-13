import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:equatable/equatable.dart';

/// The appointments, working status, and availability bands for one calendar day column.
final class StaffCalendarDay extends Equatable {
  /// Creates a day model with immutable collections.
  StaffCalendarDay({
    required this.date,
    required this.isClosed,
    required Iterable<TimeRange> availabilityBands,
    required Iterable<Appointment> appointments,
  }) : availabilityBands = List<TimeRange>.unmodifiable(availabilityBands),
       appointments = List<Appointment>.unmodifiable(appointments);

  /// The calendar date of this day column.
  final CalendarDate date;

  /// Whether the hosting branch is closed on this day.
  final bool isClosed;

  /// Working availability bands enclosed by the branch hours, sorted by start.
  final List<TimeRange> availabilityBands;

  /// Staff appointments scheduled on this date, sorted by start time.
  final List<Appointment> appointments;

  /// Total count of scheduled appointments on this date.
  int get appointmentCount => appointments.length;

  @override
  List<Object> get props => [date, isClosed, availabilityBands, appointments];
}
