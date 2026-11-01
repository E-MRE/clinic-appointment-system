import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:equatable/equatable.dart';

/// A patient-free projection of an appointment that occupies a range.
final class BookedSlot extends Equatable {
  /// Creates an occupied range for one appointment on one date.
  const BookedSlot({
    required this.appointmentId,
    required this.date,
    required this.range,
  });

  /// The appointment reserving the range.
  final String appointmentId;

  /// The date supplied by the containing day document.
  final CalendarDate date;

  /// The occupied half-open range.
  final TimeRange range;

  @override
  List<Object> get props => [appointmentId, date, range];
}
