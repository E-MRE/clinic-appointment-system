import 'package:clinic_appointment_system/core/enums/time_error_code.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/errors/time_exception.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/availability/domain/entities/availability_window.dart';
import 'package:clinic_appointment_system/features/availability/presentation/enums/availability_repeat.dart';
import 'package:clinic_appointment_system/features/availability/presentation/extensions/availability_repeat_window_factory.dart';
import 'package:equatable/equatable.dart';

/// Immutable recurrence and time selections for an availability window.
final class AvailabilityWindowDraft extends Equatable {
  /// Creates a draft, defaulting to a recurring Monday without times.
  const AvailabilityWindowDraft({
    this.repeat = AvailabilityRepeat.weekly,
    this.weekday = Weekday.monday,
    required this.date,
    this.start,
    this.end,
  });

  /// The selected recurrence strategy.
  final AvailabilityRepeat repeat;

  /// The weekday used by the recurring strategy.
  final Weekday weekday;

  /// The calendar date used by the dated strategy.
  final CalendarDate date;

  /// The selected start, or null while unset.
  final ClockTime? start;

  /// The selected end, or null while unset.
  final ClockTime? end;

  /// Builds the selected variant when both endpoints are present.
  /// Returns null while incomplete; invalid endpoints throw [TimeException].
  AvailabilityWindow? get window {
    final range = _buildRange();
    if (range == null) return null;
    return repeat.windowFactory.build(this, range);
  }

  /// The time-range failure, or null while incomplete or valid.
  TimeErrorCode? get timeError {
    try {
      _buildRange();
      return null;
    } on TimeException catch (error) {
      return error.code;
    }
  }

  /// Copies selected values, preserving endpoints omitted from the call.
  /// Use [withoutStart] or [withoutEnd] to explicitly clear an endpoint.
  AvailabilityWindowDraft copyWith({
    AvailabilityRepeat? repeat,
    Weekday? weekday,
    CalendarDate? date,
    ClockTime? start,
    ClockTime? end,
  }) {
    return AvailabilityWindowDraft(
      repeat: repeat ?? this.repeat,
      weekday: weekday ?? this.weekday,
      date: date ?? this.date,
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  /// Copies this draft with its start explicitly unset.
  AvailabilityWindowDraft withoutStart() {
    return AvailabilityWindowDraft(
      repeat: repeat,
      weekday: weekday,
      date: date,
      end: end,
    );
  }

  /// Copies this draft with its end explicitly unset.
  AvailabilityWindowDraft withoutEnd() {
    return AvailabilityWindowDraft(
      repeat: repeat,
      weekday: weekday,
      date: date,
      start: start,
    );
  }

  TimeRange? _buildRange() {
    final start = this.start;
    final end = this.end;
    if (start == null || end == null) return null;
    return TimeRange(start: start, end: end);
  }

  /// The recurrence, day, date and endpoints defining value identity.
  @override
  List<Object?> get props => [repeat, weekday, date, start, end];
}
