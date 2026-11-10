import 'package:clinic_appointment_system/core/constants/booking_constants.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/calendar_date_week.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/patient_catalog.dart';
import 'package:clinic_appointment_system/features/patient/presentation/models/staff_week_schedule_request.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// The patient's in-progress booking choices.
/// Each choice clears the choices that depend on it: a service clears the
/// staff member, a staff member or week clears the day, a day clears the slot.
final class BookingSelection {
  /// Starts on [currentWeekStart] with nothing chosen, optionally limited
  /// to the department identified by [departmentId].
  const BookingSelection.initial({
    required this.currentWeekStart,
    this.departmentId,
  }) : weekStart = currentWeekStart,
       service = null,
       staff = null,
       date = null,
       slot = null,
       query = '';

  const BookingSelection._({
    required this.currentWeekStart,
    required this.weekStart,
    required this.departmentId,
    required this.query,
    required this.service,
    required this.staff,
    required this.date,
    required this.slot,
  });

  /// The Monday of the current week; earlier weeks cannot be shown.
  final CalendarDate currentWeekStart;

  /// The Monday of the shown week.
  final CalendarDate weekStart;

  /// The department the service list is limited to, if any.
  final String? departmentId;

  /// The service search text.
  final String query;

  /// The chosen service.
  final MedicalService? service;

  /// The chosen staff member.
  final Staff? staff;

  /// The chosen day.
  final CalendarDate? date;

  /// The chosen slot on [date].
  final TimeRange? slot;

  /// Whether a week before the shown one may be shown.
  bool get canShowPreviousWeek => weekStart.isAfter(currentWeekStart);

  /// Whether service, staff member, day and slot are all chosen.
  bool get isComplete {
    return service != null && staff != null && date != null && slot != null;
  }

  /// Chooses [service] and clears the staff member, day and slot.
  BookingSelection withService(MedicalService service) {
    return _copy(service: service, staff: null, date: null, slot: null);
  }

  /// Chooses [staff] and clears the day and slot.
  BookingSelection withStaff(Staff staff) {
    return _copy(service: service, staff: staff, date: null, slot: null);
  }

  /// Shows the week starting on [weekStart] and clears the day and slot.
  BookingSelection withWeek(CalendarDate weekStart) {
    return _copy(
      weekStart: weekStart,
      service: service,
      staff: staff,
      date: null,
      slot: null,
    );
  }

  /// Chooses [date] and clears the slot.
  BookingSelection withDate(CalendarDate date) {
    return _copy(service: service, staff: staff, date: date, slot: null);
  }

  /// Chooses [slot] on the chosen day.
  BookingSelection withSlot(TimeRange slot) {
    return _copy(service: service, staff: staff, date: date, slot: slot);
  }

  /// Clears the chosen slot.
  BookingSelection withoutSlot() {
    return _copy(service: service, staff: staff, date: date, slot: null);
  }

  /// Replaces the search text.
  BookingSelection withQuery(String query) {
    return _copy(
      query: query,
      service: service,
      staff: staff,
      date: date,
      slot: slot,
    );
  }

  /// Removes the department limit.
  BookingSelection withoutDepartment() {
    return BookingSelection._(
      currentWeekStart: currentWeekStart,
      weekStart: weekStart,
      departmentId: null,
      query: query,
      service: service,
      staff: staff,
      date: date,
      slot: slot,
    );
  }

  /// Bookable services of [catalog] in the department limit whose name
  /// contains the search text, ignoring case with Turkish dotted and
  /// dotless `i` rules.
  List<MedicalService> servicesIn(PatientCatalog catalog) {
    final needle = _folded(query.trim());
    return [
      for (final item in catalog.services)
        if ((departmentId == null || item.departmentId == departmentId) &&
            _folded(item.name).contains(needle) &&
            catalog.staffFor(item).isNotEmpty)
          item,
    ];
  }

  /// The schedule to observe for the chosen staff member and service in the
  /// shown week, or null before both are chosen. An unknown branch counts
  /// as closed every day.
  StaffWeekScheduleRequest? scheduleRequest(PatientCatalog catalog) {
    final service = this.service;
    final staff = this.staff;
    if (service == null || staff == null) return null;
    return StaffWeekScheduleRequest(
      staff: staff,
      service: service,
      weekStart: weekStart,
      branchHours:
          catalog.branchById(staff.branchId)?.workingHours ??
          WorkingHours.closed(),
    );
  }

  /// Whether [request] describes this selection's staff, service and week.
  bool isScheduledBy(StaffWeekScheduleRequest request) {
    return request.staff.id == staff?.id &&
        request.service.id == service?.id &&
        request.weekStart == weekStart;
  }

  /// Whether this selection needs a different schedule than [previous].
  bool schedulesDifferentlyFrom(BookingSelection previous) {
    return previous.staff?.id != staff?.id ||
        previous.service?.id != service?.id ||
        previous.weekStart != weekStart;
  }

  /// Shows the week after the shown one.
  BookingSelection withNextWeek() {
    return withWeek(weekStart.addDays(BookingConstants.daysPerWeek));
  }

  /// Shows the week before the shown one, never before the current week.
  BookingSelection withPreviousWeek() {
    if (!canShowPreviousWeek) return this;
    return withWeek(weekStart.addDays(-BookingConstants.daysPerWeek));
  }

  static String _folded(String text) {
    return text.replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();
  }

  BookingSelection _copy({
    required MedicalService? service,
    required Staff? staff,
    required CalendarDate? date,
    required TimeRange? slot,
    CalendarDate? weekStart,
    String? query,
  }) {
    return BookingSelection._(
      currentWeekStart: currentWeekStart,
      weekStart: weekStart ?? this.weekStart,
      departmentId: departmentId,
      query: query ?? this.query,
      service: service,
      staff: staff,
      date: date,
      slot: slot,
    );
  }
}
