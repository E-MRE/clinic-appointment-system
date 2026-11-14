import 'dart:async';

import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/time/clock_today.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/staff/presentation/cubit/staff_calendar_state.dart';
import 'package:clinic_appointment_system/features/staff/presentation/enums/staff_calendar_view.dart';
import 'package:clinic_appointment_system/features/staff/presentation/extensions/staff_calendar_date_range.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_calendar_layout.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_calendar_layout_factory.dart';
import 'package:clinic_appointment_system/features/staff/presentation/models/staff_workspace.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the staff calendar view mode (day or week) and anchor date navigation.
final class StaffCalendarCubit extends Cubit<StaffCalendarState> {
  /// Creates a calendar cubit defaulting to week view and today.
  StaffCalendarCubit({
    required Clock clock,
    required StaffCalendarLayoutFactory layoutFactory,
  }) : _layoutFactory = layoutFactory,
       _clock = clock,
       super(
         StaffCalendarState(view: StaffCalendarView.week, anchor: clock.today),
       ) {
    _refreshTimer = Timer.periodic(_layoutRefreshInterval, (_) {
      _emitFor(state.view, state.anchor);
    });
  }

  int get _dayStep => 1;
  int get _weekStep => 7;

  final Clock _clock;
  final StaffCalendarLayoutFactory _layoutFactory;
  List<Appointment>? _appointments;
  StaffWorkspace? _workspace;
  Timer? _refreshTimer;

  Duration get _layoutRefreshInterval => const Duration(minutes: 1);

  /// Switches the calendar to day view.
  void showDay() {
    _emitFor(StaffCalendarView.day, state.anchor);
  }

  /// Switches the calendar to week view.
  void showWeek() {
    _emitFor(StaffCalendarView.week, state.anchor);
  }

  /// Advances the anchor by one day or one week based on the active view.
  void next() {
    final step = state.view == StaffCalendarView.week ? _weekStep : _dayStep;
    _emitFor(state.view, state.anchor.addDays(step));
  }

  /// Rewinds the anchor by one day or one week based on the active view.
  void previous() {
    final step = state.view == StaffCalendarView.week ? -_weekStep : -_dayStep;
    _emitFor(state.view, state.anchor.addDays(step));
  }

  /// Resets the anchor to today without altering the active view.
  void today() {
    _emitFor(state.view, _clock.today);
  }

  /// Sets the anchor to [date] without altering the active view.
  void selectDate(CalendarDate date) {
    _emitFor(state.view, date);
  }

  /// Supplies the latest appointment list used by the calendar layout.
  void updateAppointments(List<Appointment>? appointments) {
    _appointments = appointments;
    _emitFor(state.view, state.anchor);
  }

  /// Supplies the latest workplace schedule used by the calendar layout.
  void updateWorkspace(StaffWorkspace? workspace) {
    _workspace = workspace;
    _emitFor(state.view, state.anchor);
  }

  void _emitFor(StaffCalendarView view, CalendarDate anchor) {
    final now = _clock.now();
    final visibleDates = _visibleDates(view, anchor);
    final layout = _createLayout(visibleDates, now);
    final dayLayout = view == StaffCalendarView.day
        ? layout
        : _createLayout([anchor], now);
    emit(
      StaffCalendarState(
        view: view,
        anchor: anchor,
        layout: layout,
        dayLayout: dayLayout,
      ),
    );
  }

  List<CalendarDate> _visibleDates(
    StaffCalendarView view,
    CalendarDate anchor,
  ) {
    if (view == StaffCalendarView.day) return [anchor];
    return anchor.weekDates;
  }

  StaffCalendarLayout? _createLayout(
    List<CalendarDate> visibleDates,
    DateTime now,
  ) {
    final appointments = _appointments;
    final workspace = _workspace;
    if (appointments == null || workspace == null) return null;
    return _layoutFactory.create(
      visibleDates: visibleDates,
      appointments: appointments,
      availability: workspace.availability,
      branchHours: workspace.branch.workingHours,
      now: now,
    );
  }

  /// Stops the periodic clock refresh before closing.
  @override
  Future<void> close() async {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    await super.close();
  }
}
