import 'package:clinic_appointment_system/features/appointments/domain/actors/appointment_actor.dart';
import 'package:clinic_appointment_system/features/appointments/domain/entities/appointment.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/cubit/appointment_action_cubit.dart';
import 'package:clinic_appointment_system/features/appointments/presentation/extensions/appointment_action_context.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:clinic_appointment_system/features/auth/presentation/cubit/auth_state.dart';
import 'package:clinic_appointment_system/features/staff/presentation/visitors/staff_appointment_actor_visitor.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Resolves staff lifecycle identity and performs actions from a signed-in context.
extension StaffAppointmentActionContext on BuildContext {
  /// Builds the signed-in staff actor, or returns null when no staff session exists.
  AppointmentActor? get staffAppointmentActor {
    final state = read<AuthCubit>().state;
    if (state is AuthSignedIn) {
      final staff = state.user.staffProfile;
      if (staff != null) {
        return staff.accept(const StaffAppointmentActorVisitor());
      }
    }
    return null;
  }

  /// Performs [cubit]'s action on [appointment] as the signed-in staff member.
  Future<void> performAsStaff(
    AppointmentActionCubit cubit,
    Appointment appointment, {
    String? reason,
  }) async {
    final actor = staffAppointmentActor;
    if (actor == null) return;
    await performAppointmentAction(cubit, appointment, actor, reason: reason);
  }
}
