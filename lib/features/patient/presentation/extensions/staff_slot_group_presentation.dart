import 'package:clinic_appointment_system/core/extensions/time_range_label.dart';
import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/day_period_localization.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_slot_group.dart';

/// Localized heading of a slot group.
extension StaffSlotGroupPresentation on StaffSlotGroup {
  /// Period and window (`Sabah · 09:00–12:00`).
  String get heading {
    return LocaleKeys.patient_book_slotGroup.translate(
      args: [period.label, window.label],
    );
  }
}
