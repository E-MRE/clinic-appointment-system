import 'package:clinic_appointment_system/features/appointments/domain/enums/appointment_action.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_cubit.dart';

/// Marks an approved appointment as a no-show after its tolerance boundary.
final class AppointmentNoShowCubit extends AppointmentActionCubit {
  /// Injects the lifecycle use case.
  AppointmentNoShowCubit(super.changeStatus);

  @override
  AppointmentAction get action => AppointmentAction.markNoShow;
}
