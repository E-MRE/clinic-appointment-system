import 'package:clinic_appointment_system/core/extensions/turkish_case_folding.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/clock.dart';
import 'package:clinic_appointment_system/core/time/clock_today.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/institution/presentation/models/clinic_catalog.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/calendar_date_week.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/booking_selection.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule.dart';
import 'package:clinic_appointment_system/features/patient/presentation/services/patient_booking_staff_selector.dart';
import 'package:clinic_appointment_system/features/patient/presentation/services/staff_week_schedule_reader.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the patient's booking choices, starting in the clock's week.
final class BookingSelectionCubit extends Cubit<BookingSelection> {
  /// Starts with nothing chosen in the current week of [clock].
  BookingSelectionCubit(Clock clock, this._scheduleReader, this._staffSelector)
    : super(BookingSelection.initial(currentWeekStart: clock.today.weekStart));

  final StaffWeekScheduleReader _scheduleReader;
  final PatientBookingStaffSelector _staffSelector;
  StaffWeekSchedule? _schedule;

  /// Returns bookable catalog services matching the current search and limit.
  List<MedicalService> servicesIn(ClinicCatalog catalog) {
    final needle = state.query.trim();
    return [
      for (final service in catalog.services)
        if ((state.departmentId == null ||
                service.departmentId == state.departmentId) &&
            service.name.containsTurkishInsensitive(needle) &&
            _staffSelector
                .select(catalog: catalog, service: service)
                .isNotEmpty)
          service,
    ];
  }

  /// Returns staff matching [service] through the injected catalog selector.
  List<Staff> staffFor(ClinicCatalog catalog, MedicalService service) {
    return _staffSelector.select(catalog: catalog, service: service);
  }

  /// Limits the service list to the department identified by [departmentId];
  /// called once with the route's query parameter.
  void limitToDepartment(String? departmentId) {
    _schedule = null;
    _emitSelection(
      BookingSelection.initial(
        currentWeekStart: state.currentWeekStart,
        departmentId: departmentId,
      ),
    );
  }

  /// Removes the department limit.
  void removeDepartmentLimit() => _emitSelection(state.withoutDepartment());

  /// Replaces the service search text.
  void search(String query) => _emitSelection(state.withQuery(query));

  /// Chooses [service]; choosing the current service again changes nothing.
  void selectService(MedicalService service) {
    if (state.service?.id == service.id) return;
    _schedule = null;
    _emitSelection(state.withService(service));
  }

  /// Chooses [staff]; choosing the current staff member again changes nothing.
  void selectStaff(Staff staff) {
    if (state.staff?.id == staff.id) return;
    _schedule = null;
    _emitSelection(state.withStaff(staff));
  }

  /// Shows the following week.
  void showNextWeek() {
    _schedule = null;
    _emitSelection(state.withNextWeek());
  }

  /// Shows the previous week unless the current week is shown.
  void showPreviousWeek() {
    if (!state.canShowPreviousWeek) return;
    _schedule = null;
    _emitSelection(state.withPreviousWeek());
  }

  /// Chooses [date] and clears the slot.
  void selectDate(CalendarDate date) {
    if (state.date == date) return;
    _emitSelection(state.withDate(date));
  }

  /// Chooses [slot] on the chosen day.
  void selectSlot(TimeRange slot) => _emitSelection(state.withSlot(slot));

  /// Clears the chosen slot.
  void clearSlot() => _emitSelection(state.withoutSlot());

  /// Follows a new [schedule] of the current choices: picks the first day
  /// with a free slot when no day is chosen, and clears a chosen slot that
  /// is no longer free. Schedules of earlier choices are ignored.
  void applySchedule(StaffWeekSchedule schedule) {
    if (!state.isScheduledBy(schedule.request)) return;
    _schedule = schedule;
    final date = state.date;
    if (date == null) {
      final first = _scheduleReader.firstAvailableDay(schedule);
      if (first != null) {
        _emitSelection(state.withDate(first.date));
      } else {
        _emitSelection(state);
      }
      return;
    }
    final slot = state.slot;
    if (slot != null && !_scheduleReader.isFree(schedule, date, slot)) {
      _emitSelection(state.withoutSlot());
      return;
    }
    _emitSelection(state);
  }

  void _emitSelection(BookingSelection selection) {
    final schedule = _schedule;
    final date = selection.date;
    if (schedule == null ||
        date == null ||
        !selection.isScheduledBy(schedule.request)) {
      emit(selection.withScheduleDay(null));
      return;
    }
    emit(selection.withScheduleDay(_scheduleReader.dayOn(schedule, date)));
  }
}
