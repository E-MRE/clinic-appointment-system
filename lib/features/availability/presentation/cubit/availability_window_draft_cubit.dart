import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/time/clock_time.dart';
import 'package:clinic_appointment_system/core/time/clock_today.dart';
import 'package:clinic_appointment_system/features/availability/presentation/enums/availability_repeat.dart';
import 'package:clinic_appointment_system/features/availability/presentation/models/availability_window_draft.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds draft selections; domain value objects own time validation.
final class AvailabilityWindowDraftCubit
    extends Cubit<AvailabilityWindowDraft> {
  /// Injects the clock for today's date in new and reset drafts.
  AvailabilityWindowDraftCubit(Clock clock)
    : _clock = clock,
      super(AvailabilityWindowDraft(date: clock.today));

  final Clock _clock;

  /// Starts a recurring window for [day] with both times unset.
  void startWeekly(Weekday day) {
    emit(AvailabilityWindowDraft(weekday: day, date: state.date));
  }

  /// Starts a dated window for today with both times unset.
  void startOneOff() {
    emit(
      AvailabilityWindowDraft(
        repeat: AvailabilityRepeat.oneOff,
        weekday: state.weekday,
        date: _clock.today,
      ),
    );
  }

  /// Selects the recurrence while preserving the other draft values.
  void selectRepeat(AvailabilityRepeat repeat) {
    emit(state.copyWith(repeat: repeat));
  }

  /// Selects the weekday for a recurring window.
  void selectWeekday(Weekday weekday) {
    emit(state.copyWith(weekday: weekday));
  }

  /// Selects the calendar date for a dated window.
  void selectDate(CalendarDate date) {
    emit(state.copyWith(date: date));
  }

  /// Replaces the selected start time.
  void changeStart(ClockTime start) {
    emit(state.copyWith(start: start));
  }

  /// Replaces the selected end time.
  void changeEnd(ClockTime end) {
    emit(state.copyWith(end: end));
  }

  /// Restores a recurring Monday draft for today with both times unset.
  void reset() {
    emit(AvailabilityWindowDraft(date: _clock.today));
  }
}
