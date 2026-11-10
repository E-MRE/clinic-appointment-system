import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/time/clock_today.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/calendar_date_week.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/booking_selection.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the patient's booking choices, starting in the clock's week.
final class BookingSelectionCubit extends Cubit<BookingSelection> {
  /// Starts with nothing chosen in the current week of [clock].
  BookingSelectionCubit(Clock clock)
    : super(BookingSelection.initial(currentWeekStart: clock.today.weekStart));

  /// Limits the service list to the department identified by [departmentId];
  /// called once with the route's query parameter.
  void limitToDepartment(String? departmentId) {
    emit(
      BookingSelection.initial(
        currentWeekStart: state.currentWeekStart,
        departmentId: departmentId,
      ),
    );
  }

  /// Removes the department limit.
  void removeDepartmentLimit() => emit(state.withoutDepartment());

  /// Replaces the service search text.
  void search(String query) => emit(state.withQuery(query));

  /// Chooses [service]; choosing the current service again changes nothing.
  void selectService(MedicalService service) {
    if (state.service?.id == service.id) return;
    emit(state.withService(service));
  }

  /// Chooses [staff]; choosing the current staff member again changes nothing.
  void selectStaff(Staff staff) {
    if (state.staff?.id == staff.id) return;
    emit(state.withStaff(staff));
  }

  /// Shows the following week.
  void showNextWeek() => emit(state.withNextWeek());

  /// Shows the previous week unless the current week is shown.
  void showPreviousWeek() {
    if (!state.canShowPreviousWeek) return;
    emit(state.withPreviousWeek());
  }

  /// Chooses [date] and clears the slot.
  void selectDate(CalendarDate date) {
    if (state.date == date) return;
    emit(state.withDate(date));
  }

  /// Chooses [slot] on the chosen day.
  void selectSlot(TimeRange slot) => emit(state.withSlot(slot));

  /// Clears the chosen slot.
  void clearSlot() => emit(state.withoutSlot());

  /// Follows a new [schedule] of the current choices: picks the first day
  /// with a free slot when no day is chosen, and clears a chosen slot that
  /// is no longer free. Schedules of earlier choices are ignored.
  void applySchedule(StaffWeekSchedule schedule) {
    if (!state.isScheduledBy(schedule.request)) return;
    final date = state.date;
    if (date == null) {
      final first = schedule.firstAvailableDay;
      if (first != null) emit(state.withDate(first.date));
      return;
    }
    final slot = state.slot;
    if (slot != null && !schedule.isFree(date, slot)) {
      emit(state.withoutSlot());
    }
  }
}
