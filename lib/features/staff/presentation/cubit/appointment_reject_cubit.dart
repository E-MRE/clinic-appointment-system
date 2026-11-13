import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_cubit.dart';

/// Rejects pending appointment requests as their assigned staff member,
/// with an optional reason, one request at a time.
final class AppointmentRejectCubit extends AppointmentActionCubit {
  /// Injects the lifecycle use case.
  AppointmentRejectCubit(super.changeStatus);

  @override
  AppointmentAction get action => AppointmentAction.reject;
}
