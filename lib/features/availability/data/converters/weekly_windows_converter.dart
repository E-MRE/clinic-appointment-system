import 'package:clinic_appointment_system/core/data/converters/time_range_converter.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/errors/time_exception.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/weekly_window.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts recurring windows to and from a complete weekday map.
final class WeeklyWindowsConverter
    extends JsonConverter<List<WeeklyWindow>, Map<String, dynamic>> {
  /// Creates a converter for all weekdays.
  const WeeklyWindowsConverter();

  @override
  List<WeeklyWindow> fromJson(Map<String, dynamic> json) {
    final days = Weekday.values.map((day) => day.name).toSet();
    if (json.length != days.length || !days.containsAll(json.keys)) {
      throw const FormatException(
        'Weekly windows must contain exactly seven weekdays.',
      );
    }
    final windows = <WeeklyWindow>[];
    const converter = TimeRangeConverter();
    for (final day in Weekday.values) {
      final ranges = json[day.name];
      if (ranges is! List) {
        throw const FormatException('Each weekday must contain a list.');
      }
      for (final range in ranges) {
        if (range is! Map || range.keys.any((key) => key is! String)) {
          throw const FormatException('Each range must be a map.');
        }
        try {
          windows.add(
            WeeklyWindow(
              weekday: day,
              range: converter.fromJson(Map<String, dynamic>.from(range)),
            ),
          );
        } on TimeException {
          throw const FormatException('A range must end after it starts.');
        }
      }
    }
    return windows;
  }

  @override
  Map<String, dynamic> toJson(List<WeeklyWindow> object) {
    const converter = TimeRangeConverter();
    return {
      for (final day in Weekday.values)
        day.name: [
          for (final window in object)
            if (window.weekday == day) converter.toJson(window.range),
        ],
    };
  }
}
