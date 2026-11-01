import 'package:clinic_appointment_system/core/constants/firestore_constants.dart';
import 'package:clinic_appointment_system/core/data/converters/clock_time_converter.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts a time range to and from its Firestore map.
final class TimeRangeConverter
    extends JsonConverter<TimeRange, Map<String, dynamic>> {
  /// Creates a converter for start and end clock times.
  const TimeRangeConverter();

  int get _fieldCount => 2;

  @override
  TimeRange fromJson(Map<String, dynamic> json) {
    if (json.length != _fieldCount ||
        !json.containsKey(FirestoreConstants.start) ||
        !json.containsKey(FirestoreConstants.end)) {
      throw const FormatException('A range must contain start and end.');
    }
    final start = json[FirestoreConstants.start];
    final end = json[FirestoreConstants.end];
    if (start is! String || end is! String) {
      throw const FormatException('A range must use string times.');
    }
    const converter = ClockTimeConverter();
    return TimeRange(
      start: converter.fromJson(start),
      end: converter.fromJson(end),
    );
  }

  @override
  Map<String, dynamic> toJson(TimeRange object) {
    const converter = ClockTimeConverter();
    return {
      FirestoreConstants.start: converter.toJson(object.start),
      FirestoreConstants.end: converter.toJson(object.end),
    };
  }
}
