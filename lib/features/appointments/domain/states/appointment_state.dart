import 'package:clinic_appointment_system/core/constants/appointment_constants.dart';
import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_error_code.dart';
import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_status.dart';
import 'package:clinic_appointment_system/features/appointments/domain/states/transitions/approvable_state.dart';
import 'package:clinic_appointment_system/features/appointments/domain/states/transitions/completable_state.dart';
import 'package:clinic_appointment_system/features/appointments/domain/states/transitions/no_show_markable_state.dart';
import 'package:clinic_appointment_system/features/appointments/domain/states/transitions/patient_cancellable_state.dart';
import 'package:clinic_appointment_system/features/appointments/domain/states/transitions/rejectable_state.dart';
import 'package:clinic_appointment_system/features/appointments/domain/states/transitions/staff_cancellable_state.dart';
import 'package:clinic_appointment_system/features/appointments/domain/states/transitions/transition_decision.dart';

part 'approved_appointment_state.dart';
part 'cancelled_by_patient_appointment_state.dart';
part 'cancelled_by_staff_appointment_state.dart';
part 'completed_appointment_state.dart';
part 'no_show_appointment_state.dart';
part 'pending_appointment_state.dart';
part 'rejected_appointment_state.dart';

/// Shared lifecycle checks and optional capabilities.
/// Subclasses must supply slot occupancy and expose only supported transitions.
abstract base class AppointmentState {
  /// Creates a stateless lifecycle policy.
  const AppointmentState();

  /// Subclasses must report whether appointments in this state occupy a slot.
  bool get occupiesSlot;

  /// Subclasses supporting approve must return their capability; otherwise null.
  ApprovableState? get approvable => null;

  /// Subclasses supporting reject must return their capability; otherwise null.
  RejectableState? get rejectable => null;

  /// Subclasses supporting cancelByPatient must return their capability; otherwise null.
  PatientCancellableState? get patientCancellable => null;

  /// Subclasses supporting cancelByStaff must return their capability; otherwise null.
  StaffCancellableState? get staffCancellable => null;

  /// Subclasses supporting complete must return their capability; otherwise null.
  CompletableState? get completable => null;

  /// Subclasses supporting markNoShow must return their capability; otherwise null.
  NoShowMarkableState? get noShowMarkable => null;

  TransitionDecision _cancelForPatient(
    Appointment appointment,
    AppointmentActor by,
    DateTime at,
  ) {
    final error = _permissionError(by.mayActAsPatient(appointment.patientId));
    if (error != null) {
      return TransitionDecision.deny(error);
    }
    if (!at.isBefore(appointment.startsAt)) {
      return const TransitionDecision.deny(AppointmentErrorCode.tooLate);
    }
    return const TransitionDecision.allow(AppointmentStatus.cancelledByPatient);
  }

  AppointmentErrorCode? _reachedError(DateTime at, DateTime earliest) {
    if (at.isBefore(earliest)) {
      return AppointmentErrorCode.tooEarly;
    }
    return null;
  }

  AppointmentErrorCode? _permissionError(bool permitted) {
    if (!permitted) {
      return AppointmentErrorCode.notPermitted;
    }
    return null;
  }

  TransitionDecision _decide(
    AppointmentStatus next,
    AppointmentErrorCode? error,
  ) {
    if (error != null) {
      return TransitionDecision.deny(error);
    }
    return TransitionDecision.allow(next);
  }
}
