import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/results/appointment_booking_result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/results/appointment_result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/rules/appointment_violation.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';

/// Atomic appointment persistence and owner-scoped observation.
abstract interface class AppointmentRepository {
  /// Reads both day projections and evaluates [check] on each transaction attempt.
  /// Violations cause no writes. Provider and malformed-record failures are results.
  Future<AppointmentBookingResult> book(
    Appointment candidate,
    List<AppointmentViolation> Function(
      List<BookedSlot> staffSlots,
      List<BookedSlot> patientSlots,
    )
    check,
  );

  /// Reads only the appointment and applies [change] on each transaction attempt.
  /// Rejected transitions and storage failures return error results without writes.
  Future<AppointmentResult> changeStatus(
    String id,
    AppointmentResult Function(Appointment current) change,
  );

  /// Watches a patient's appointments in ascending date and start order.
  /// Storage failures emit an error result whose message is an error-code name.
  Stream<DataResult<List<Appointment>>> watchPatientAppointments(
    String patientId,
  );

  /// Watches staff appointments from [from] through [through], both inclusive,
  /// ordered by date and start. Failures emit an error-code name in message.
  Stream<DataResult<List<Appointment>>> watchStaffAppointments(
    String staffId,
    CalendarDate from,
    CalendarDate through,
  );

  /// Watches occupied slots on [date], or an empty list for a missing day.
  /// Failures emit an error result whose message is an error-code name.
  Stream<DataResult<List<BookedSlot>>> watchStaffBookedSlots(
    String staffId,
    CalendarDate date,
  );
}
