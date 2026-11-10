import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/patient/presentation/enums/booking_cell_style.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_slot.dart';

/// Localized text and cell style of a slot on the booking page.
extension StaffSlotPresentation on StaffSlot {
  /// Start time (`11:20`).
  String get label => '${range.start}';

  /// Announced text; a taken slot says it is occupied.
  String get semanticsLabel {
    if (!isTaken) return label;
    return LocaleKeys.patient_book_slotTaken.translate(args: [label]);
  }

  /// Taken, selected or available.
  BookingCellStyle cellStyle({required bool isSelected}) {
    if (isTaken) return BookingCellStyle.taken;
    if (isSelected) return BookingCellStyle.selected;
    return BookingCellStyle.available;
  }
}
