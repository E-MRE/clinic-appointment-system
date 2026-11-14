import 'dart:async';

import 'package:clinic_appointment_system/core/errors/data_result.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/repositories/appointment_repository.dart';
import 'package:clinic_appointment_system/features/appointments/domain/results/appointment_result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';

import 'keyed_streams.dart';

/// Patient appointment streams plus a status change that runs the real
/// domain transition on [stored] unless a failure or a pending completer
/// is configured. Booked slots stream per `staffId/date` key; booking runs
/// the real rule check against no occupied slots unless a failure or a
/// pending completer is configured.
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

  /// Booked slot streams keyed by [bookedSlotsKey].
  final KeyedStreams<BookedSlot> bookedSlots = KeyedStreams<BookedSlot>();

  /// Candidates passed to [book].
  final List<Appointment> bookedCandidates = [];

  /// Error returned by [book] instead of running the check, when set.
  AppointmentErrorCode? bookFailure;

  /// Completes [book] later, when set.
  Completer<DataResult<Appointment>>? bookPending;

  /// The [bookedSlots] key of [staffId] on [date].
  static String bookedSlotsKey(String staffId, CalendarDate date) {
    return '$staffId/$date';
  }

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
  ) async {
    bookedCandidates.add(candidate);
    if (bookPending case final Completer<DataResult<Appointment>> completer) {
      return completer.future;
    }
    if (bookFailure case final AppointmentErrorCode code) {
      return DataResult.error(errorCode: code);
    }
    final violations = check(const [], const []);
    if (violations.isNotEmpty) {
      return DataResult.error(errorCode: violations.first.code);
    }
    return DataResult.success(data: candidate.withId('booked'));
  }

  @override
  Stream<DataResult<List<Appointment>>> watchStaffAppointments(
    String staffId,
    CalendarDate from,
    CalendarDate through,
  ) => throw UnimplementedError();

  @override
  Stream<DataResult<List<Appointment>>> watchAdminAppointments(
    CalendarDate from,
    CalendarDate through,
  ) => throw UnimplementedError();

  @override
  Stream<DataResult<List<Appointment>>> watchPendingAppointments() =>
      throw UnimplementedError();

  @override
  Stream<DataResult<List<BookedSlot>>> watchStaffBookedSlots(
    String staffId,
    CalendarDate date,
  ) => bookedSlots.watch(bookedSlotsKey(staffId, date));
}
