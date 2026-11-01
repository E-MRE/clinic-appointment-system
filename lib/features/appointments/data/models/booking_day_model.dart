import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/core/data/converters/calendar_date_converter.dart';
import 'package:clinic_appointment_system/features/appointments/data/converters/booked_slot_converter.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// A date-keyed occupied-slot projection with no patient information.
final class BookingDayModel {
  /// Copies occupied slots to keep the day immutable.
  BookingDayModel({
    required List<BookedSlot> slots,
    required this.lastAppointmentId,
  }) : slots = List.unmodifiable(slots);

  /// Decodes a stored day; only an absent document counts as an empty projection.
  factory BookingDayModel.fromJson(String dateId, Map<String, dynamic>? json) {
    final date = const CalendarDateConverter().fromJson(dateId);
    if (json == null) return BookingDayModel(slots: [], lastAppointmentId: '');
    final entries = json[FirestoreConstants.slots] as List<dynamic>;
    return BookingDayModel(
      slots: entries
          .map(
            (entry) => const BookedSlotConverter().fromJson(
              Map<String, dynamic>.from(entry as Map),
              date,
            ),
          )
          .toList(),
      lastAppointmentId: json[FirestoreConstants.lastAppointmentId] as String,
    );
  }

  final List<BookedSlot> slots;
  final String lastAppointmentId;

  /// Appends the new entry at the end, preserving every existing entry's order.
  Map<String, dynamic> appending(BookedSlot slot) {
    return {
      FirestoreConstants.slots: [
        for (final existing in slots)
          const BookedSlotConverter().toJson(existing),
        const BookedSlotConverter().toJson(slot),
      ],
      FirestoreConstants.lastAppointmentId: slot.appointmentId,
      FirestoreConstants.updatedAt: FieldValue.serverTimestamp(),
    };
  }
}
