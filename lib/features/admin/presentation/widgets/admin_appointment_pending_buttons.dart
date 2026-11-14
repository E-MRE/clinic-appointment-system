part of 'admin_appointment_row_actions.dart';

/// Reads both action states before exposing the pending row controls.
final class _AdminAppointmentPendingButtons extends StatelessWidget {
  const _AdminAppointmentPendingButtons({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppointmentApproveCubit, AppointmentActionState>(
      builder: (context, approveState) {
        return BlocBuilder<AppointmentRejectCubit, AppointmentActionState>(
          builder: (context, rejectState) {
            return _AdminAppointmentPendingButtonRow(
              appointment: appointment,
              approveState: approveState,
              rejectState: rejectState,
            );
          },
        );
      },
    );
  }
}
