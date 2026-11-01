import 'package:clinic_appointment_system/core/time/calendar_date.dart';
import 'package:clinic_appointment_system/core/time/time_range.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status_state.dart';
import 'package:clinic_appointment_system/features/appointments/domain/errors/appointment_exception.dart';
import 'package:clinic_appointment_system/features/appointments/domain/states/appointment_state.dart';
import 'package:clinic_appointment_system/features/appointments/domain/value_objects/appointment_status_change.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:equatable/equatable.dart';

/// An immutable appointment with an audited, state-controlled lifecycle.
final class Appointment extends Equatable {
  /// Unpersisted appointment identifier.
  static const String unsavedId = '';

  /// Requests a pending appointment on behalf of its own patient.
  /// Throws notPermitted for other identities or roles.
  factory Appointment.request({
    String id = unsavedId,
    required String patientId,
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

  /// The stored identifier, or unsavedId before persistence.
  final String id;

  /// The patient who requested this appointment.
  final String patientId;

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
  /// Returns a new appointment with one audit entry; throws on a lifecycle
  /// violation.
  Appointment approve({required AppointmentActor by, required DateTime at}) =>
      _changed(_state.approve(this, by: by, at: at), by, at);

  /// Rejects a pending request as its assigned staff member or any admin.
  /// Returns a new appointment with one audit entry; throws on a lifecycle
  /// violation.
  Appointment reject({required AppointmentActor by, required DateTime at}) =>
      _changed(_state.reject(this, by: by, at: at), by, at);

  /// Cancels a pending or approved appointment as its own patient before start.
  /// Returns a new appointment with one audit entry; throws on a lifecycle
  /// violation.
  Appointment cancelByPatient({
    required AppointmentActor by,
    required DateTime at,
  }) => _changed(_state.cancelByPatient(this, by: by, at: at), by, at);

  /// Cancels an approved appointment as its assigned staff member or any admin.
  /// Returns a new appointment with one audit entry; throws on a lifecycle
  /// violation.
  Appointment cancelByStaff({
    required AppointmentActor by,
    required DateTime at,
  }) => _changed(_state.cancelByStaff(this, by: by, at: at), by, at);

  /// Completes an approved appointment as assigned staff or any admin,
  /// at or after its start.
  /// Returns a new appointment with one audit entry; throws on a lifecycle
  /// violation.
  Appointment complete({required AppointmentActor by, required DateTime at}) =>
      _changed(_state.complete(this, by: by, at: at), by, at);

  /// Marks an approved no-show as assigned staff at or after the tolerance
  /// boundary. Admins cannot mark no-shows.
  /// Returns a new appointment with one audit entry; throws on a lifecycle
  /// violation.
  Appointment markNoShow({
    required AppointmentActor by,
    required DateTime at,
  }) => _changed(_state.markNoShow(this, by: by, at: at), by, at);

  /// Whether this appointment reserves its booked slot.
  bool get occupiesSlot => _state.occupiesSlot;

  AppointmentState get _state => status.state;

  Appointment _changed(
    AppointmentStatus next,
    AppointmentActor by,
    DateTime at,
  ) {
    return Appointment.restore(
      id: id,
      patientId: patientId,
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
        ),
      ],
    );
  }

  /// All stored values defining appointment equality.
  @override
  List<Object> get props => [
    id,
    patientId,
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
