import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_cubit.dart';

/// Cancels an approved appointment as its assigned staff member, with an optional reason.
final class AppointmentStaffCancelCubit extends AppointmentActionCubit {
  /// Injects the lifecycle use case.
  AppointmentStaffCancelCubit(super.changeStatus);

  @override
  AppointmentAction get action => AppointmentAction.cancelByStaff;
}
