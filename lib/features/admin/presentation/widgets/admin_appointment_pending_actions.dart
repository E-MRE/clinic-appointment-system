part of 'admin_appointment_row_actions.dart';

/// Approve and reject controls for one pending administrator row.
final class _AdminAppointmentPendingActions extends StatelessWidget {
  const _AdminAppointmentPendingActions({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AppointmentApproveCubit, AppointmentActionState>(
          listener: (context, state) {
            context.showAppointmentActionFeedback(
              state,
              successMessage: LocaleKeys.staffRequests_approved.translate(),
            );
          },
        ),
        BlocListener<AppointmentRejectCubit, AppointmentActionState>(
          listener: (context, state) {
            context.showAppointmentActionFeedback(
              state,
              successMessage: LocaleKeys.staffRequests_rejected.translate(),
            );
          },
        ),
      ],
      child: _AdminAppointmentPendingButtons(appointment: appointment),
    );
  }
}
