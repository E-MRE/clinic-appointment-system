import 'package:clinic_appointment_system/features/appointments/domain/actors/admin_appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_cubit.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_action_context.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/users/domain/enums/user_role.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Resolves an administrator identity and applies its offered appointment actions.
extension AdminAppointmentActionContext on BuildContext {
  /// The signed-in administrator actor, or null outside an admin session.
  AdminAppointmentActor? get adminAppointmentActor {
    final state = read<AuthCubit>().state;
    if (state is AuthSignedIn && state.user.role == UserRole.admin) {
      return AdminAppointmentActor(id: state.user.id);
    }
    return null;
  }

  /// Performs [cubit]'s lifecycle action as the signed-in administrator.
  Future<void> performAsAdmin(
    AppointmentActionCubit cubit,
    Appointment appointment, {
    String? reason,
  }) async {
    final actor = adminAppointmentActor;
    if (actor == null) return;
    await performAppointmentAction(cubit, appointment, actor, reason: reason);
  }
}
