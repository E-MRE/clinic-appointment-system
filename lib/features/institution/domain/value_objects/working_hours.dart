import 'package:clinic_appointment_system/core/errors/institution_exception.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/institution_error_code.dart';
import 'package:clinic_appointment_system/features/institution/domain/enums/weekday.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/clock_time.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/time_range.dart';

/// Immutable weekly working hours with validated, sorted ranges per weekday.
final class WorkingHours {
  /// Creates working hours and rejects overlapping ranges on the same day.
  factory WorkingHours(Map<Weekday, List<TimeRange>> ranges) {
    final copiedRanges = <Weekday, List<TimeRange>>{};
    for (final day in Weekday.values) {
      final sortedRanges = List<TimeRange>.of(ranges[day] ?? const [])
        ..sort((first, second) => first.start.compareTo(second.start));
      for (var index = 1; index < sortedRanges.length; index++) {
        if (sortedRanges[index - 1].overlaps(sortedRanges[index])) {
          throw const InstitutionException(
            InstitutionErrorCode.overlappingRanges,
          );
        }
      }
      copiedRanges[day] = List<TimeRange>.unmodifiable(sortedRanges);
    }
    return WorkingHours._(
      Map<Weekday, List<TimeRange>>.unmodifiable(copiedRanges),
    );
  }

  /// Creates a week in which every day is closed.
  WorkingHours.closed()
    : _ranges = Map<Weekday, List<TimeRange>>.unmodifiable({
        for (final day in Weekday.values) day: const <TimeRange>[],
      });

  const WorkingHours._(this._ranges);

  final Map<Weekday, List<TimeRange>> _ranges;

  /// The sorted working ranges for [day], or an empty list when closed.
  List<TimeRange> rangesOn(Weekday day) => _ranges[day]!;

  /// Whether [day] has no working ranges.
  bool isClosedOn(Weekday day) => rangesOn(day).isEmpty;

  /// Whether the branch is open at [time] on [day].
  bool isOpenAt(Weekday day, ClockTime time) {
    return rangesOn(day).any((range) => range.contains(time));
  }

  /// The open weekdays in Monday-to-Sunday order.
  Iterable<Weekday> get openDays {
    return Weekday.values.where((day) => !isClosedOn(day));
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! WorkingHours) return false;
    return Weekday.values.every(
      (day) => _sameRanges(rangesOn(day), other.rangesOn(day)),
    );
  }

  @override
  int get hashCode {
    return Object.hashAll(
      Weekday.values.map(
        (day) => Object.hash(day, Object.hashAll(rangesOn(day))),
      ),
    );
  }

  bool _sameRanges(List<TimeRange> first, List<TimeRange> second) {
    if (first.length != second.length) return false;
    for (var index = 0; index < first.length; index++) {
      if (first[index] != second[index]) return false;
    }
    return true;
  }
}
