import 'package:clinic_appointment_system/core/extensions/date_time_formatting.dart';
import 'package:clinic_appointment_system/core/localization/weekday_localization.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_calendar_date_range.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_calendar_layout.dart';

/// Presentation title formatting for the staff calendar header.
extension StaffCalendarHeaderTitle on StaffCalendarLayout {
  int get _singleDayCount => 1;

  /// Formats the header title based on whether the layout spans a single day or a week.
  String get headerTitle {
    if (days.isEmpty) return '';
    if (days.length == _singleDayCount) {
      return _dayTitle(days.first.date);
    }
    return _weekTitle(days.first.date, days.last.date);
  }

  /// Formats a single day title.
  String _dayTitle(CalendarDate date) {
    final dayMonth = date.startOfDay.dayMonthLabel();
    return '${date.weekday.label}, $dayMonth';
  }

  /// Formats an inclusive week title.
  String _weekTitle(CalendarDate start, CalendarDate end) {
    if (start.year == end.year && start.month == end.month) {
      final endDayMonth = end.startOfDay.dayMonthLabel();
      return '${start.day} – $endDayMonth';
    }
    final startShort = start.startOfDay.dayShortMonthLabel();
    final endShort = end.startOfDay.dayShortMonthLabel();
    return '$startShort – $endShort';
  }
}
