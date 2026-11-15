import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clinic_appointment_system/features/appointments/domain/results/appointment_result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';

/// Controls appointment observation and lifecycle changes in presentation tests.
final class StaffAppointmentRepository implements AppointmentRepository {
  /// Creates the broadcast stream used by staff list subscribers.
  StaffAppointmentRepository()
    : events = StreamController<DataResult<List<Appointment>>>.broadcast();

  /// Latest streamed appointment lists.
  final StreamController<DataResult<List<Appointment>>> events;

  /// Appointments read by lifecycle transitions.
  final Map<String, Appointment> stored = {};

  /// Queries requested by staff list subscribers.
  final List<(String, CalendarDate, CalendarDate)> watchedQueries = [];

  /// Date ranges requested by administrator list subscribers.
  final List<(CalendarDate, CalendarDate)> watchedAdminQueries = [];

  /// Appointment ids passed to lifecycle transitions.
  final List<String> changedIds = [];

  /// Optional deferred lifecycle response.
  Completer<AppointmentResult>? pendingChange;

  /// Optional typed lifecycle failure.
  AppointmentErrorCode? changeFailure;

  /// Emits the latest staff appointment list to active subscribers.
  void emit(List<Appointment> appointments) {
    for (final appointment in appointments) {
      stored[appointment.id] = appointment;
    }
    events.add(DataResult.success(data: appointments));
  }

  @override
  Future<DataResult<Appointment>> book(
    Appointment candidate,
    AppointmentBookingCheck check,
  ) {
    throw UnimplementedError();
  }

  @override
  Future<AppointmentResult> changeStatus(
    String id,
    AppointmentStatusChange change,
  ) async {
    changedIds.add(id);
    if (pendingChange case final completer?) return completer.future;
    if (changeFailure case final errorCode?) {
      return AppointmentResult.error(errorCode);
    }
    final current = stored[id];
    if (current == null) {
      return const AppointmentResult.error(AppointmentErrorCode.notFound);
    }
    final result = change(current);
    if (result.appointment case final updated?) stored[id] = updated;
    return result;
  }

  @override
  Stream<DataResult<List<Appointment>>> watchPatientAppointments(
    String patientId,
  ) {
    throw UnimplementedError();
  }

  @override
  Stream<DataResult<List<Appointment>>> watchStaffAppointments(
    String staffId,
    CalendarDate from,
    CalendarDate through,
  ) {
    watchedQueries.add((staffId, from, through));
    return events.stream;
  }

  @override
  Stream<DataResult<List<Appointment>>> watchAdminAppointments(
    CalendarDate from,
    CalendarDate through,
  ) {
    watchedAdminQueries.add((from, through));
    return events.stream;
  }

  @override
  Stream<DataResult<List<Appointment>>> watchPendingAppointments() {
    return events.stream;
  }

  @override
  Stream<DataResult<List<BookedSlot>>> watchStaffBookedSlots(
    String staffId,
    CalendarDate date,
  ) {
    return const Stream.empty();
  }
}
