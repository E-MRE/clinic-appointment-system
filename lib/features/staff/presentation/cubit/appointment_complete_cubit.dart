import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_cubit.dart';

/// Marks approved appointments completed as their assigned staff member.
final class AppointmentCompleteCubit extends AppointmentActionCubit {
  /// Injects the lifecycle use case.
  AppointmentCompleteCubit(super.changeStatus);

  @override
  AppointmentAction get action => AppointmentAction.complete;
}
