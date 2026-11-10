import 'package:clinic_appointment_system/core/constants/booking_constants.dart';
import 'package:clinic_appointment_system/core/enums/weekday.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/institution/domain/value_objects/working_hours.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/entities/medical_service.dart';
import 'package:clinic_appointment_system/features/patient/presentation/extensions/calendar_date_week.dart';
import 'package:clinic_appointment_system/features/users/domain/entities/staff.dart';

/// The staff member, service and week whose schedule is observed.
final class StaffWeekScheduleRequest {
  /// Creates a request for the week starting on Monday [weekStart].
  StaffWeekScheduleRequest({
    required this.staff,
    required this.service,
    required this.weekStart,
    required this.branchHours,
  }) : dates = List<CalendarDate>.unmodifiable(
         List<CalendarDate>.generate(
           branchHours.isClosedOn(Weekday.sunday)
               ? BookingConstants.alwaysListedDays
               : BookingConstants.daysPerWeek,
           weekStart.addDays,
         ),
       );

  /// The staff member providing the service.
  final Staff staff;

  /// The requested service; its duration sizes the slots.
  final MedicalService service;

  /// The Monday of the observed week.
  final CalendarDate weekStart;

  /// Working hours of the staff member's branch.
  final WorkingHours branchHours;

  /// Monday through Saturday, plus Sunday when the branch opens on Sunday.
  final List<CalendarDate> dates;
}
