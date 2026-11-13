part of 'staff_appointment_dialog.dart';

/// Shows the latest localized lifecycle failure while keeping the dialog open.
final class _StaffAppointmentDialogError extends StatelessWidget {
  const _StaffAppointmentDialogError();

  @override
  Widget build(BuildContext context) {
    final states = [
      context.watch<AppointmentApproveCubit>().state,
      context.watch<AppointmentRejectCubit>().state,
      context.watch<AppointmentCompleteCubit>().state,
      context.watch<AppointmentNoShowCubit>().state,
      context.watch<AppointmentStaffCancelCubit>().state,
    ];
    final failure = states.whereType<AppointmentActionFailure>().firstOrNull;
    if (failure == null) return const SizedBox.shrink();
    return AppMessageBanner(
      message: failure.errorCode.message,
      variant: AppMessageBannerVariant.error,
    );
  }
}
