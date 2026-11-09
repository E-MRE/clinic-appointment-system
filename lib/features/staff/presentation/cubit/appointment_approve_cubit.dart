import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_cubit.dart';

/// Approves pending appointment requests as their assigned staff member,
/// one request at a time.
final class AppointmentApproveCubit extends AppointmentActionCubit {
  /// Injects the lifecycle use case.
  AppointmentApproveCubit(super.changeStatus);

  @override
  AppointmentAction get action => AppointmentAction.approve;
}
