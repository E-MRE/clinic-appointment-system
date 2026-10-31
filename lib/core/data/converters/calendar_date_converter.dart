import 'package:clinic_appointment_system/core/errors/time_exception.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:json_annotation/json_annotation.dart';

/// Converts calendar dates to and from strict ISO date strings.
final class CalendarDateConverter extends JsonConverter<CalendarDate, String> {
  /// Creates a converter for `yyyy-MM-dd` dates.
  const CalendarDateConverter();

  int get _yearGroup => 1;
  int get _monthGroup => 2;
  int get _dayGroup => 3;

  @override
  CalendarDate fromJson(String json) {
    final match = RegExp(
      r'^([0-9]{4})-([0-9]{2})-([0-9]{2})$',
    ).firstMatch(json);
    if (match == null) {
      throw const FormatException('Calendar date must use yyyy-MM-dd.');
    }
    try {
      return CalendarDate(
        year: int.parse(match.group(_yearGroup) ?? ''),
        month: int.parse(match.group(_monthGroup) ?? ''),
        day: int.parse(match.group(_dayGroup) ?? ''),
      );
    } on TimeException {
      throw const FormatException('Calendar date must be valid.');
    }
  }

  @override
  String toJson(CalendarDate object) => object.toString();
}
