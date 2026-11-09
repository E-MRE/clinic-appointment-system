import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clinic_appointment_system/features/appointments/domain/results/appointment_result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';

/// Patient appointment streams plus a status change that runs the real
/// domain transition on [stored] unless a failure or a pending completer
/// is configured.
final class PatientAppointmentRepository implements AppointmentRepository {
  final StreamController<DataResult<List<Appointment>>> events =
      StreamController.broadcast();

  /// Appointments by id, read by [changeStatus].
  final Map<String, Appointment> stored = {};

  /// Patient ids requested by [watchPatientAppointments].
  final List<String> watchedPatients = [];

  /// Ids passed to [changeStatus].
  final List<String> changedIds = [];

  /// Results of the transitions [changeStatus] applied.
  final List<AppointmentResult> changeResults = [];

  /// Error returned instead of applying the transition, when set.
  AppointmentErrorCode? failure;

  /// Exception thrown instead of applying the transition, when set.
  Exception? exception;

  /// Completes the change later, when set.
  Completer<AppointmentResult>? pending;

  /// Emits [appointments] as the patient's latest list.
  void emit(List<Appointment> appointments) {
    for (final appointment in appointments) {
      stored[appointment.id] = appointment;
    }
    events.add(DataResult.success(data: appointments));
  }

  @override
  Stream<DataResult<List<Appointment>>> watchPatientAppointments(
    String patientId,
  ) {
    watchedPatients.add(patientId);
    return events.stream;
  }

  @override
  Future<AppointmentResult> changeStatus(
    String id,
    AppointmentStatusChange change,
  ) async {
    changedIds.add(id);
    if (exception case final Exception error) throw error;
    if (pending case final Completer<AppointmentResult> completer) {
      return completer.future;
    }
    if (failure case final AppointmentErrorCode code) {
      return AppointmentResult.error(code);
    }
    final current = stored[id];
    if (current == null) {
      return const AppointmentResult.error(AppointmentErrorCode.notFound);
    }
    final result = change(current);
    changeResults.add(result);
    return result;
  }

  @override
  Future<DataResult<Appointment>> book(
    Appointment candidate,
    AppointmentBookingCheck check,
  ) => throw UnimplementedError();

  @override
  Stream<DataResult<List<Appointment>>> watchStaffAppointments(
    String staffId,
    CalendarDate from,
    CalendarDate through,
  ) => throw UnimplementedError();

  @override
  Stream<DataResult<List<BookedSlot>>> watchStaffBookedSlots(
    String staffId,
    CalendarDate date,
  ) => throw UnimplementedError();
}
