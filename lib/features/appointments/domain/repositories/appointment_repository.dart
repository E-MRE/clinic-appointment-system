import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/results/appointment_result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_violation.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';

/// Checks a booking against the slots read inside the booking transaction.
typedef AppointmentBookingCheck =
    List<AppointmentViolation> Function(
      List<BookedSlot> staffSlots,
      List<BookedSlot> patientSlots,
    );

/// Applies a lifecycle transition to the appointment read inside the
/// status-change transaction.
typedef AppointmentStatusChange =
    AppointmentResult Function(Appointment current);

/// Atomic appointment persistence and owner-scoped observation.
abstract interface class AppointmentRepository {
  /// Reads both day projections and evaluates [check] on each transaction
  /// attempt. Violations cause no writes; the result carries the first
  /// violation's code as `errorCode`. Storage failures are results too.
  Future<DataResult<Appointment>> book(
    Appointment candidate,
    AppointmentBookingCheck check,
  );

  /// Reads only the appointment and applies [change] on each transaction
  /// attempt. Rejected transitions and storage failures return error results
  /// without writes.
  Future<AppointmentResult> changeStatus(
    String id,
    AppointmentStatusChange change,
  );

  /// Watches a patient's appointments in ascending date and start order.
  /// Failures emit an error result with an `AppointmentErrorCode`.
  Stream<DataResult<List<Appointment>>> watchPatientAppointments(
    String patientId,
  );

  /// Watches staff appointments from [from] through [through], both inclusive,
  /// ordered by date and start. Failures emit an error result with an
  /// `AppointmentErrorCode`.
  Stream<DataResult<List<Appointment>>> watchStaffAppointments(
    String staffId,
    CalendarDate from,
    CalendarDate through,
  );

  /// Watches occupied slots on [date], or an empty list for a missing day.
  /// Failures emit an error result with an `AppointmentErrorCode`.
  Stream<DataResult<List<BookedSlot>>> watchStaffBookedSlots(
    String staffId,
    CalendarDate date,
  );
}
