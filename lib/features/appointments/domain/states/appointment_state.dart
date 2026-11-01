import 'package:clinic_appointment_system/core/constants/appointment_constants.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/errors/appointment_exception.dart';

part 'approved_appointment_state.dart';
part 'cancelled_by_patient_appointment_state.dart';
part 'cancelled_by_staff_appointment_state.dart';
part 'completed_appointment_state.dart';
part 'no_show_appointment_state.dart';
part 'pending_appointment_state.dart';
part 'rejected_appointment_state.dart';

/// Default-deny lifecycle behavior; subclasses override only allowed transitions
/// and must supply whether their status occupies a booked slot.
abstract base class AppointmentState {
  /// Creates a stateless lifecycle policy.
  const AppointmentState();

  /// Subclasses must report whether appointments in this state occupy a slot.
  bool get occupiesSlot;

  /// Rejects approve unless a subclass explicitly allows the transition.
  AppointmentStatus approve(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) {
    throw const AppointmentException(AppointmentErrorCode.invalidTransition);
  }

  /// Rejects reject unless a subclass explicitly allows the transition.
  AppointmentStatus reject(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) {
    throw const AppointmentException(AppointmentErrorCode.invalidTransition);
  }

  /// Rejects cancelByPatient unless a subclass explicitly allows the transition.
  AppointmentStatus cancelByPatient(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) {
    throw const AppointmentException(AppointmentErrorCode.invalidTransition);
  }

  /// Rejects cancelByStaff unless a subclass explicitly allows the transition.
  AppointmentStatus cancelByStaff(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) {
    throw const AppointmentException(AppointmentErrorCode.invalidTransition);
  }

  /// Rejects complete unless a subclass explicitly allows the transition.
  AppointmentStatus complete(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) {
    throw const AppointmentException(AppointmentErrorCode.invalidTransition);
  }

  /// Rejects markNoShow unless a subclass explicitly allows the transition.
  AppointmentStatus markNoShow(
    Appointment appointment, {
    required AppointmentActor by,
    required DateTime at,
  }) {
    throw const AppointmentException(AppointmentErrorCode.invalidTransition);
  }

  AppointmentStatus _cancelForPatient(
    Appointment appointment,
    AppointmentActor by,
    DateTime at,
  ) {
    _requirePermission(by.mayActAsPatient(appointment.patientId));
    if (!at.isBefore(appointment.startsAt)) {
      throw const AppointmentException(AppointmentErrorCode.tooLate);
    }
    return AppointmentStatus.cancelledByPatient;
  }

  void _requireReached(DateTime at, DateTime earliest) {
    if (at.isBefore(earliest)) {
      throw const AppointmentException(AppointmentErrorCode.tooEarly);
    }
  }

  void _requirePermission(bool permitted) {
    if (!permitted) {
      throw const AppointmentException(AppointmentErrorCode.notPermitted);
    }
  }
}
