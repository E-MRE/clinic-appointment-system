import 'package:clinic_appointment_system/core/time/time_range.dart';

/// Formats a time range for display.
extension TimeRangeLabel on TimeRange {
  /// The endpoints separated by an en dash.
  String get label => '$start–$end';
}
