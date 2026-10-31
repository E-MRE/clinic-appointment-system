import 'package:clinic_appointment_system/core/enums/time_error_code.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/errors/time_exception.dart';
import 'package:clinic_appointment_system/core/extensions/date_time_weekday.dart';
import 'package:equatable/equatable.dart';

/// An immutable calendar date without a time of day.
final class CalendarDate extends Equatable implements Comparable<CalendarDate> {
  static int get _yearWidth => 4;
  static int get _componentWidth => 2;

  /// Creates a date, rejecting components that do not form a real date.
  factory CalendarDate({
    required int year,
    required int month,
    required int day,
  }) {
    try {
      final date = DateTime.utc(year, month, day);
      if (date.year != year || date.month != month || date.day != day) {
        throw const TimeException(TimeErrorCode.invalidDate);
      }
      return CalendarDate._(year: year, month: month, day: day);
    } on ArgumentError {
      throw const TimeException(TimeErrorCode.invalidDate);
    }
  }

  /// Copies the date components of [value], discarding its time.
  factory CalendarDate.fromDateTime(DateTime value) {
    return CalendarDate(year: value.year, month: value.month, day: value.day);
  }

  const CalendarDate._({
    required this.year,
    required this.month,
    required this.day,
  });

  /// The calendar year.
  final int year;

  /// The calendar month.
  final int month;

  /// The day of the month.
  final int day;

  /// The weekday on which this date falls.
  Weekday get weekday => DateTime.utc(year, month, day).toWeekday();

  /// Whether this date precedes [other].
  bool isBefore(CalendarDate other) => compareTo(other) < 0;

  /// Whether this date follows [other].
  bool isAfter(CalendarDate other) => compareTo(other) > 0;

  @override
  int compareTo(CalendarDate other) {
    final yearOrder = year.compareTo(other.year);
    if (yearOrder != 0) return yearOrder;
    final monthOrder = month.compareTo(other.month);
    if (monthOrder != 0) return monthOrder;
    return day.compareTo(other.day);
  }

  @override
  List<Object> get props => [year, month, day];

  @override
  String toString() {
    final paddedYear = year.toString().padLeft(_yearWidth, '0');
    final paddedMonth = month.toString().padLeft(_componentWidth, '0');
    final paddedDay = day.toString().padLeft(_componentWidth, '0');
    return '$paddedYear-$paddedMonth-$paddedDay';
  }
}
