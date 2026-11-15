import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';

/// Orders appointments by their date, start time and identifier, or by start time.
final class AppointmentStartComparator {
  /// Creates an appointment start comparator.
  const AppointmentStartComparator();

  int get _equalOrder => 0;

  /// Compares [first] and [second] by date, start time, then identifier.
  int call(Appointment first, Appointment second) {
    final dateOrder = first.date.compareTo(second.date);
    if (dateOrder != _equalOrder) return dateOrder;
    final startOrder = first.range.start.compareTo(second.range.start);
    if (startOrder != _equalOrder) return startOrder;
    return first.id.compareTo(second.id);
  }

  /// Compares [first] and [second] by start time, leaving ties equal.
  int compareByStartTime(Appointment first, Appointment second) {
    return first.startsAt.compareTo(second.startsAt);
  }

  /// Compares [first] and [second] by start time in descending order.
  int compareByStartTimeDescending(Appointment first, Appointment second) {
    return second.startsAt.compareTo(first.startsAt);
  }
}
