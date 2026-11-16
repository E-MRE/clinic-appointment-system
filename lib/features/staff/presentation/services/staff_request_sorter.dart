import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_request_sort.dart';

/// Orders staff appointment requests by their appointment date or request time.
final class StaffRequestSorter {
  /// Creates the request ordering policy.
  const StaffRequestSorter();

  /// Compares [first] and [second] using [sort], then breaks ties by id.
  int compare(StaffRequestSort sort, Appointment first, Appointment second) {
    final order = switch (sort) {
      StaffRequestSort.byDate => first.startsAt.compareTo(second.startsAt),
      StaffRequestSort.byRequestTime => first.history.first.at.compareTo(
        second.history.first.at,
      ),
    };
    if (order != 0) return order;
    return first.id.compareTo(second.id);
  }

  /// Returns a new list of [appointments] ordered by [sort].
  List<Appointment> sort(
    Iterable<Appointment> appointments, {
    required StaffRequestSort sort,
  }) {
    return appointments.toList()
      ..sort((first, second) => compare(sort, first, second));
  }
}
