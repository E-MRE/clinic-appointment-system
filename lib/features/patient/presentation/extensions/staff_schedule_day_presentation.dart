import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:clinic_appointment_system/core/localization/weekday_localization.dart';
import 'package:clinic_appointment_system/features/patient/presentation/enums/booking_cell_style.dart';
import 'package:clinic_appointment_system/features/patient/presentation/enums/booking_day_status.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_schedule_day.dart';

/// Localized text and cell style of a day in the booking day strip.
extension StaffScheduleDayPresentation on StaffScheduleDay {
  /// Abbreviated weekday (`Per`).
  String get weekdayLabel => date.weekday.shortLabel;

  /// Day of the month (`29`).
  String get dayLabel => '${date.day}';

  /// Free slot count, `Dolu` or `Kapalı`.
  String get statusLabel {
    return switch (status) {
      BookingDayStatus.available => LocaleKeys.patient_book_dayFree.translate(
        args: ['$freeCount'],
      ),
      BookingDayStatus.full => LocaleKeys.patient_book_dayFull.translate(),
      BookingDayStatus.closed => LocaleKeys.patient_book_dayClosed.translate(),
    };
  }

  /// Selected, available or (closed, full) unavailable.
  BookingCellStyle cellStyle({required bool isSelected}) {
    if (!isSelectable) return BookingCellStyle.unavailable;
    if (isSelected) return BookingCellStyle.selected;
    return BookingCellStyle.available;
  }
}
