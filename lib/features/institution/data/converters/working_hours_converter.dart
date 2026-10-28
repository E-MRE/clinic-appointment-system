import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/features/institution/data/converters/clock_time_converter.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/weekday.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/time_range.dart';
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

    const clockTimeConverter = ClockTimeConverter();
    final ranges = <Weekday, List<TimeRange>>{};
    for (final day in Weekday.values) {
      final rawRanges = json[day.name];
      if (rawRanges is! List) {
        throw FormatException('Working hours for ${day.name} must be a list.');
      }

      ranges[day] = rawRanges
          .map((rawRange) {
            if (rawRange is! Map ||
                rawRange.length != 2 ||
                !rawRange.keys.toSet().containsAll({
                  FirestoreConstants.start,
                  FirestoreConstants.end,
                })) {
              throw FormatException(
                'A range for ${day.name} must contain start and end.',
              );
            }

            final start = rawRange[FirestoreConstants.start];
            final end = rawRange[FirestoreConstants.end];
            if (start is! String || end is! String) {
              throw FormatException(
                'A range for ${day.name} must use string times.',
              );
            }

            return TimeRange(
              start: clockTimeConverter.fromJson(start),
              end: clockTimeConverter.fromJson(end),
            );
          })
          .toList(growable: false);
    }

    return WorkingHours(ranges);
  }

  @override
  Map<String, dynamic> toJson(WorkingHours object) {
    const clockTimeConverter = ClockTimeConverter();
    return {
      for (final day in Weekday.values)
        day.name: [
          for (final range in object.rangesOn(day))
            {
              FirestoreConstants.start: clockTimeConverter.toJson(range.start),
              FirestoreConstants.end: clockTimeConverter.toJson(range.end),
            },
        ],
    };
  }
}
