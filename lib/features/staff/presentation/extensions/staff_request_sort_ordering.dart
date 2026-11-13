import 'package:clinic_appointment_system/core/localization/localization_extension.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_request_sort.dart';
import 'package:clinic_appointment_system/generated/localization/lang/locale_keys.g.dart';

/// Comparator and ordering helpers for [StaffRequestSort].
extension StaffRequestSortOrdering on StaffRequestSort {
  /// Compares two appointments according to this sort strategy.
  int compare(Appointment first, Appointment second) {
    final order = switch (this) {
      StaffRequestSort.byDate => first.startsAt.compareTo(second.startsAt),
      StaffRequestSort.byRequestTime => first.history.first.at.compareTo(
        second.history.first.at,
      ),
    };
    if (order != 0) return order;
    return first.id.compareTo(second.id);
  }

  /// Returns a new list of [appointments] sorted by this strategy.
  List<Appointment> sort(Iterable<Appointment> appointments) {
    return appointments.toList()..sort(compare);
  }

  /// The localized label for the sort toggle.
  String get label {
    return switch (this) {
      StaffRequestSort.byDate =>
        LocaleKeys.staffRequests_sort_byDate.translate(),
      StaffRequestSort.byRequestTime =>
        LocaleKeys.staffRequests_sort_byRequestTime.translate(),
    };
  }
}
