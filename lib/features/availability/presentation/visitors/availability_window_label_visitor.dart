import 'package:clinic_appointment_system/core/extensions/time_range_label.dart';
import 'package:clinic_appointment_system/core/localization/app_formatters.dart';
import 'package:clinic_appointment_system/core/localization/weekday_localization.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window_visitor.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/one_off_window.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/weekly_window.dart';

/// Localized recurring and dated window labels using double dispatch.
final class AvailabilityWindowLabelVisitor
    implements AvailabilityWindowVisitor<String> {
  /// Creates a stateless window label visitor.
  const AvailabilityWindowLabelVisitor();

  /// Full weekday and recurring time range.
  @override
  String visitWeekly(WeeklyWindow window) =>
      '${window.weekday.label} ${window.range.label}';

  /// Localized day-month, full weekday and dated time range.
  @override
  String visitOneOff(OneOffWindow window) {
    final date = window.date;
    final dayMonth = AppFormatters.formatDayMonth(
      DateTime(date.year, date.month, date.day),
    );
    return '$dayMonth ${window.weekday.label} · ${window.range.label}';
  }
}
