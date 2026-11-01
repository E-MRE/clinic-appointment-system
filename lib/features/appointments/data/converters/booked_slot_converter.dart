import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/core/data/converters/time_range_converter.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';

/// Adapts occupied ranges; the containing day supplies their date.
final class BookedSlotConverter {
  /// Creates an occupied-range converter.
  const BookedSlotConverter();

  /// Rebuilds a slot from a day entry and its containing date.
  BookedSlot fromJson(Map<String, dynamic> json, CalendarDate date) {
    return BookedSlot(
      appointmentId: json[FirestoreConstants.appointmentId] as String,
      date: date,
      range: const TimeRangeConverter().fromJson({
        FirestoreConstants.start: json[FirestoreConstants.start],
        FirestoreConstants.end: json[FirestoreConstants.end],
      }),
    );
  }

  /// Serializes exactly the entry used for appends and array removal.
  Map<String, dynamic> toJson(BookedSlot slot) {
    return {
      FirestoreConstants.appointmentId: slot.appointmentId,
      ...const TimeRangeConverter().toJson(slot.range),
    };
  }
}
