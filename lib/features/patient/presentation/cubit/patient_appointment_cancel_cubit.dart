import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_cubit.dart';

/// Cancels an appointment as its patient, one request at a time.
final class PatientAppointmentCancelCubit extends AppointmentActionCubit {
  /// Injects the lifecycle use case.
  PatientAppointmentCancelCubit(super.changeStatus);

  @override
  AppointmentAction get action => AppointmentAction.cancelByPatient;
}
