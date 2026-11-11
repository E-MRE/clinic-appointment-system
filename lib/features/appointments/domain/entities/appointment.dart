import 'package:clinic_appointment_system/core/constants/appointment_constants.dart';
import 'package:clinic_appointment_system/core/constants/entity_constants.dart';
import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status_state.dart';
import 'package:clinic_appointment_system/features/appointments/domain/errors/appointment_exception.dart';
import 'package:clinic_appointment_system/features/appointments/domain/results/appointment_result.dart';
import 'package:clinic_appointment_system/features/appointments/domain/states/appointment_state.dart';
import 'package:clinic_appointment_system/features/appointments/domain/states/transitions/transition_decision.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/booked_slot.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:equatable/equatable.dart';

/// An immutable appointment with an audited, state-controlled lifecycle.
final class Appointment extends Equatable {
  /// Requests a pending appointment on behalf of its own patient.
  /// Throws notPermitted for other identities or roles.
  factory Appointment.request({
    String id = EntityConstants.unsavedId,
    required String patientId,
    required String patientName,
    required String staffId,
    required String branchId,
    required String departmentId,
    required String serviceId,
    required String serviceName,
    required Money fee,
    required CalendarDate date,
    required TimeRange range,
    required AppointmentActor by,
    required DateTime at,
  }) {
    if (!by.mayActAsPatient(patientId)) {
      throw const AppointmentException(AppointmentErrorCode.notPermitted);
    }
    return Appointment.restore(
      id: id,
      patientId: patientId,
      patientName: patientName,
      staffId: staffId,
      branchId: branchId,
      departmentId: departmentId,
      serviceId: serviceId,
      serviceName: serviceName,
      fee: fee,
      date: date,
      range: range,
      status: AppointmentStatus.pending,
      history: [
        AppointmentStatusChange(
          status: AppointmentStatus.pending,
          byUserId: by.id,
          byRole: by.role,
          at: at,
        ),
      ],
    );
  }

  /// Rebuilds stored fields and copies the supplied oldest-first history.
  /// Throws invalidHistory if history is empty or its last status disagrees.
  Appointment.restore({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.staffId,
    required this.branchId,
    required this.departmentId,
    required this.serviceId,
    required this.serviceName,
    required this.fee,
    required this.date,
    required this.range,
    required this.status,
    required List<AppointmentStatusChange> history,
  }) : history = List<AppointmentStatusChange>.unmodifiable(history) {
    if (this.history.isEmpty || this.history.last.status != status) {
      throw const AppointmentException(AppointmentErrorCode.invalidHistory);
    }
  }

  /// The stored identifier, or [EntityConstants.unsavedId] before persistence.
  final String id;

  /// The patient who requested this appointment.
  final String patientId;

  /// The patient's full name captured at booking.
  final String patientName;

  /// The doctor or technician assigned to this appointment.
  final String staffId;

  /// The branch hosting this appointment.
  final String branchId;

  /// The department providing the service.
  final String departmentId;

  /// The booked medical service identifier.
  final String serviceId;

  /// The service name captured when the appointment was requested.
  final String serviceName;

  /// The fee captured when the appointment was requested.
  final Money fee;

  /// The local calendar date of the appointment.
  final CalendarDate date;

  /// The appointment time range on its calendar date.
  final TimeRange range;

  /// The current lifecycle status.
  final AppointmentStatus status;

  /// Unmodifiable audit entries in oldest-first order.
  final List<AppointmentStatusChange> history;

  /// Copies this appointment with its client-generated persistence identifier.
  Appointment withId(String id) {
    return Appointment.restore(
      id: id,
      patientId: patientId,
      patientName: patientName,
      staffId: staffId,
      branchId: branchId,
      departmentId: departmentId,
      serviceId: serviceId,
      serviceName: serviceName,
      fee: fee,
      date: date,
      range: range,
      status: status,
      history: history,
    );
  }

  /// The optional reason attached to the current status, if any.
  String? get statusReason => history.last.reason;

  /// The duration derived from the booked time range.
  Duration get duration => Duration(minutes: range.durationMinutes);

  /// The appointment's start moment in the local timezone.
  DateTime get startsAt {
    return DateTime(
      date.year,
      date.month,
      date.day,
      range.start.hour,
      range.start.minute,
    );
  }

  /// Approves a pending request as its assigned staff member or any admin.
  /// Returns a result with a new appointment and one audit entry, or an error.
  AppointmentResult approve({
    required AppointmentActor by,
    required DateTime at,
  }) {
    return _changed(_state.approvable?.approve(this, by: by, at: at), by, at);
  }

  /// Rejects a pending request as its assigned staff member or any admin.
  /// Returns a result with a new appointment and one audit entry, or an error.
  AppointmentResult reject({
    required AppointmentActor by,
    required DateTime at,
    String? reason,
  }) {
    return _changedWithReason(
      _state.rejectable?.reject(this, by: by, at: at),
      by,
      at,
      reason,
    );
  }

  /// Cancels a pending or approved appointment as its own patient before start.
  /// Returns a result with a new appointment and one audit entry, or an error.
  AppointmentResult cancelByPatient({
    required AppointmentActor by,
    required DateTime at,
  }) {
    return _changed(
      _state.patientCancellable?.cancelByPatient(this, by: by, at: at),
      by,
      at,
    );
  }

  /// Cancels an approved appointment as its assigned staff member or any admin.
  /// Returns a result with a new appointment and one audit entry, or an error.
  AppointmentResult cancelByStaff({
    required AppointmentActor by,
    required DateTime at,
    String? reason,
  }) {
    return _changedWithReason(
      _state.staffCancellable?.cancelByStaff(this, by: by, at: at),
      by,
      at,
      reason,
    );
  }

  /// Completes an approved appointment as assigned staff or any admin,
  /// at or after its start.
  /// Returns a result with a new appointment and one audit entry, or an error.
  AppointmentResult complete({
    required AppointmentActor by,
    required DateTime at,
  }) {
    return _changed(_state.completable?.complete(this, by: by, at: at), by, at);
  }

  /// Marks an approved no-show as assigned staff at or after the tolerance
  /// boundary. Admins cannot mark no-shows.
  /// Returns a result with a new appointment and one audit entry, or an error.
  AppointmentResult markNoShow({
    required AppointmentActor by,
    required DateTime at,
  }) {
    return _changed(
      _state.noShowMarkable?.markNoShow(this, by: by, at: at),
      by,
      at,
    );
  }

  /// Whether this appointment reserves its booked slot.
  bool get occupiesSlot => _state.occupiesSlot;

  /// The occupied projection, or null when this status releases the range.
  BookedSlot? get bookedSlot {
    if (!occupiesSlot) return null;
    return BookedSlot(appointmentId: id, date: date, range: range);
  }

  AppointmentState get _state => status.state;

  /// Trims [reason]; a blank reason becomes null.
  String? _normalizeReason(String? reason) {
    if (reason == null) return null;
    final trimmed = reason.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  /// Applies [decision] with the normalized [reason] on its audit entry,
  /// or returns reasonTooLong when the reason exceeds the allowed length.
  AppointmentResult _changedWithReason(
    TransitionDecision? decision,
    AppointmentActor by,
    DateTime at,
    String? reason,
  ) {
    final normalized = _normalizeReason(reason);
    if (normalized != null &&
        normalized.length > AppointmentConstants.statusReasonMaxLength) {
      return const AppointmentResult.error(AppointmentErrorCode.reasonTooLong);
    }
    return _changed(decision, by, at, reason: normalized);
  }

  AppointmentResult _changed(
    TransitionDecision? decision,
    AppointmentActor by,
    DateTime at, {
    String? reason,
  }) {
    final next = decision?.next;
    if (next == null) {
      return AppointmentResult.error(
        decision?.errorCode ?? AppointmentErrorCode.invalidTransition,
      );
    }
    return AppointmentResult.success(
      Appointment.restore(
        id: id,
        patientId: patientId,
        patientName: patientName,
        staffId: staffId,
        branchId: branchId,
        departmentId: departmentId,
        serviceId: serviceId,
        serviceName: serviceName,
        fee: fee,
        date: date,
        range: range,
        status: next,
        history: [
          ...history,
          AppointmentStatusChange(
            status: next,
            byUserId: by.id,
            byRole: by.role,
            at: at,
            reason: reason,
          ),
        ],
      ),
    );
  }

  /// All stored values defining appointment equality.
  @override
  List<Object> get props => [
    id,
    patientId,
    patientName,
    staffId,
    branchId,
    departmentId,
    serviceId,
    serviceName,
    fee,
    date,
    range,
    status,
    history,
  ];
}
