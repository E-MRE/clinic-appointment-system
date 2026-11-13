import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_calendar_view.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_calendar_date_range.dart';
import 'package:equatable/equatable.dart';

/// State of the staff calendar navigation, view mode, and visible dates.
final class StaffCalendarState extends Equatable {
  /// Creates a calendar state.
  const StaffCalendarState({required this.view, required this.anchor});

  /// The active view mode (day or week).
  final StaffCalendarView view;

  /// The focal date used to compute visible days.
  final CalendarDate anchor;

  /// The dates currently visible according to [view] and [anchor].
  ///
  /// For [StaffCalendarView.week], returns Monday through Sunday of [anchor]'s week.
  /// For [StaffCalendarView.day], returns a single-element list containing [anchor].
  List<CalendarDate> get visibleDates => switch (view) {
    StaffCalendarView.week => anchor.weekDates,
    StaffCalendarView.day => [anchor],
  };

  /// Copies this state with optional replacement values.
  StaffCalendarState copyWith({StaffCalendarView? view, CalendarDate? anchor}) {
    return StaffCalendarState(
      view: view ?? this.view,
      anchor: anchor ?? this.anchor,
    );
  }

  @override
  List<Object> get props => [view, anchor];
}
