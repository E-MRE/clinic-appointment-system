import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/time/clock_today.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_calendar_state.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_calendar_view.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_calendar_date_range.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the staff calendar view mode (day or week) and anchor date navigation.
final class StaffCalendarCubit extends Cubit<StaffCalendarState> {
  /// Creates a calendar cubit defaulting to week view and today.
  StaffCalendarCubit({required Clock clock})
    : _clock = clock,
      super(
        StaffCalendarState(view: StaffCalendarView.week, anchor: clock.today),
      );

  int get _dayStep => 1;
  int get _weekStep => 7;

  final Clock _clock;

  /// Switches the calendar to day view.
  void showDay() {
    emit(state.copyWith(view: StaffCalendarView.day));
  }

  /// Switches the calendar to week view.
  void showWeek() {
    emit(state.copyWith(view: StaffCalendarView.week));
  }

  /// Advances the anchor by one day or one week based on the active view.
  void next() {
    final step = state.view == StaffCalendarView.week ? _weekStep : _dayStep;
    emit(state.copyWith(anchor: state.anchor.addDays(step)));
  }

  /// Rewinds the anchor by one day or one week based on the active view.
  void previous() {
    final step = state.view == StaffCalendarView.week ? -_weekStep : -_dayStep;
    emit(state.copyWith(anchor: state.anchor.addDays(step)));
  }

  /// Resets the anchor to today without altering the active view.
  void today() {
    emit(state.copyWith(anchor: _clock.today));
  }

  /// Sets the anchor to [date] without altering the active view.
  void selectDate(CalendarDate date) {
    emit(state.copyWith(anchor: date));
  }
}
