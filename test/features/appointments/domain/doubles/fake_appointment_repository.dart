import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clinic_appointment_system/features/appointments/domain/results/appointment_result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';

/// Executes callbacks against supplied transaction facts without a provider.
final class FakeAppointmentRepository implements AppointmentRepository {
  List<BookedSlot> staffSlots = [];
  List<BookedSlot> patientSlots = [];
  Appointment? current;
  AppointmentBookingCheck? check;
  Stream<DataResult<List<Appointment>>> appointments = const Stream.empty();
  Stream<DataResult<List<BookedSlot>>> slots = const Stream.empty();
  String? watchedOwner;
  CalendarDate? watchedFrom;
  CalendarDate? watchedThrough;

  @override
  Future<DataResult<Appointment>> book(
    Appointment candidate,
    AppointmentBookingCheck check,
  ) async {
    this.check = check;
    final violations = check(staffSlots, patientSlots);
    if (violations.isNotEmpty) {
      return DataResult.error(errorCode: violations.first.code);
    }
    current = candidate;
    return DataResult.success(data: candidate);
  }

  @override
  Future<AppointmentResult> changeStatus(
    String id,
    AppointmentStatusChange change,
  ) async {
    final appointment = current;
    if (appointment == null) throw StateError('Supply a current appointment.');
    return change(appointment);
  }

  @override
  Stream<DataResult<List<Appointment>>> watchPatientAppointments(
    String patientId,
  ) {
    watchedOwner = patientId;
    return appointments;
  }

  @override
  Stream<DataResult<List<Appointment>>> watchStaffAppointments(
    String staffId,
    CalendarDate from,
    CalendarDate through,
  ) {
    watchedOwner = staffId;
    watchedFrom = from;
    watchedThrough = through;
    return appointments;
  }

  @override
  Stream<DataResult<List<BookedSlot>>> watchStaffBookedSlots(
    String staffId,
    CalendarDate date,
  ) {
    watchedOwner = staffId;
    watchedFrom = date;
    return slots;
  }
}
