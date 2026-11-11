import 'package:clinic_appointment_system/core/localization/app_formatters.dart';
import 'package:clinic_appointment_system/core/localization/weekday_localization.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_calendar_date_range.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_calendar_layout.dart';

/// Presentation title formatting for the staff calendar header.
extension StaffCalendarHeaderTitle on StaffCalendarLayout {
  static const int _singleDayCount = 1;

  /// Formats the header title based on whether the layout spans a single day or a week.
  String get headerTitle {
    if (days.isEmpty) return '';
    if (days.length == _singleDayCount) {
      return _dayTitle(days.first.date);
    }
    return _weekTitle(days.first.date, days.last.date);
  }

  /// Formats a single day title (`Pazartesi, 26 Ekim`).
  String _dayTitle(CalendarDate date) {
    final dayMonth = AppFormatters.formatDayMonth(date.startOfDay);
    return '${date.weekday.label}, $dayMonth';
  }

  /// Formats an inclusive week title (`26 – 31 Ekim` or `30 Eki – 4 Kas`).
  String _weekTitle(CalendarDate start, CalendarDate end) {
    if (start.year == end.year && start.month == end.month) {
      final endDayMonth = AppFormatters.formatDayMonth(end.startOfDay);
      return '${start.day} – $endDayMonth';
    }
    final startShort = AppFormatters.formatDayShortMonth(start.startOfDay);
    final endShort = AppFormatters.formatDayShortMonth(end.startOfDay);
    return '$startShort – $endShort';
  }
}
