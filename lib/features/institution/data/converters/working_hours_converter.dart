import 'package:clinic_appointment_system/core/data/converters/time_range_converter.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts weekly working hours to and from the complete Firestore map.
final class WorkingHoursConverter
    extends JsonConverter<WorkingHours, Map<String, dynamic>> {
  /// Creates a converter that stores all seven weekdays.
  const WorkingHoursConverter();

  @override
  WorkingHours fromJson(Map<String, dynamic> json) {
    final weekdays = Weekday.values.map((day) => day.name).toSet();
    if (json.length != weekdays.length || !weekdays.containsAll(json.keys)) {
      throw const FormatException(
        'Working hours must contain exactly the seven weekday keys.',
      );
    }

    const converter = TimeRangeConverter();
    final ranges = <Weekday, List<TimeRange>>{};
    for (final day in Weekday.values) {
      final rawRanges = json[day.name];
      if (rawRanges is! List) {
        throw FormatException('Working hours for ${day.name} must be a list.');
      }
      ranges[day] = rawRanges
          .map((Object? rawRange) {
            if (rawRange is! Map ||
                rawRange.keys.any((key) => key is! String)) {
              throw FormatException('A range for ${day.name} must be a map.');
            }
            return converter.fromJson(Map<String, dynamic>.from(rawRange));
          })
          .toList(growable: false);
    }
    return WorkingHours(ranges);
  }

  @override
  Map<String, dynamic> toJson(WorkingHours object) {
    const converter = TimeRangeConverter();
    return {
      for (final day in Weekday.values)
        day.name: [
          for (final range in object.rangesOn(day)) converter.toJson(range),
        ],
    };
  }
}
