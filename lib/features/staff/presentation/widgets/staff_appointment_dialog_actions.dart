part of 'staff_appointment_dialog.dart';

/// Builds the offered action buttons and captures reasons for destructive actions.
final class _StaffAppointmentDialogActions extends StatelessWidget {
  const _StaffAppointmentDialogActions({
    required this.appointment,
    required this.offers,
  });

  final Appointment appointment;
  final List<StaffAppointmentActionOffer> offers;

  @override
  Widget build(BuildContext context) {
    final approveState = context.watch<AppointmentApproveCubit>().state;
    final rejectState = context.watch<AppointmentRejectCubit>().state;
    final completeState = context.watch<AppointmentCompleteCubit>().state;
    final noShowState = context.watch<AppointmentNoShowCubit>().state;
    final cancelState = context.watch<AppointmentStaffCancelCubit>().state;
    final isBusy =
        approveState is AppointmentActionInProgress ||
        rejectState is AppointmentActionInProgress ||
        completeState is AppointmentActionInProgress ||
        noShowState is AppointmentActionInProgress ||
        cancelState is AppointmentActionInProgress;
    final rejectOffer = _offerFor(AppointmentAction.reject);
    final approveOffer = _offerFor(AppointmentAction.approve);
    final completeOffer = _offerFor(AppointmentAction.complete);
    final noShowOffer = _offerFor(AppointmentAction.markNoShow);
    final cancelOffer = _offerFor(AppointmentAction.cancelByStaff);

    if (appointment.status == AppointmentStatus.pending) {
      return _StaffAppointmentDialogActionBar(
        hints: _hints,
        buttons: [
          if (rejectOffer != null)
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                foregroundColor: context.colorScheme.error,
                side: BorderSide(color: context.colorScheme.error),
              ),
              onPressed: isBusy || !rejectOffer.isEnabled
                  ? null
                  : () => _reject(context),
              child: rejectState is AppointmentActionInProgress
                  ? _StaffAppointmentDialogProgress(
                      label: LocaleKeys.staffRequests_reject.translate(),
                    )
                  : Text(LocaleKeys.staffRequests_rejectAction.translate()),
            ),
          if (approveOffer != null)
            FilledButton(
              onPressed: isBusy || !approveOffer.isEnabled
                  ? null
                  : () => context.performAsStaff(
                      context.read<AppointmentApproveCubit>(),
                      appointment,
                    ),
              child: approveState is AppointmentActionInProgress
                  ? _StaffAppointmentDialogProgress(
                      label: LocaleKeys.staffRequests_approving.translate(),
                    )
                  : Text(LocaleKeys.staffRequests_approve.translate()),
            ),
        ],
      );
    }

    if (appointment.status == AppointmentStatus.approved) {
      return _StaffAppointmentDialogActionBar(
        hints: _hints,
        buttons: [
          if (completeOffer != null)
            FilledButton(
              onPressed: isBusy || !completeOffer.isEnabled
                  ? null
                  : () => context.performAsStaff(
                      context.read<AppointmentCompleteCubit>(),
                      appointment,
                    ),
              child: completeState is AppointmentActionInProgress
                  ? _StaffAppointmentDialogProgress(
                      label: LocaleKeys.staffAppointmentDialog_complete
                          .translate(),
                    )
                  : Text(
                      LocaleKeys.staffAppointmentDialog_complete.translate(),
                    ),
            ),
          if (noShowOffer != null)
            OutlinedButton(
              onPressed: isBusy || !noShowOffer.isEnabled
                  ? null
                  : () => context.performAsStaff(
                      context.read<AppointmentNoShowCubit>(),
                      appointment,
                    ),
              child: noShowState is AppointmentActionInProgress
                  ? _StaffAppointmentDialogProgress(
                      label: LocaleKeys.staffAppointmentDialog_noShow
                          .translate(),
                    )
                  : Text(LocaleKeys.staffAppointmentDialog_noShow.translate()),
            ),
          if (cancelOffer != null)
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: context.colorScheme.error,
              ),
              onPressed: isBusy || !cancelOffer.isEnabled
                  ? null
                  : () => _cancel(context),
              child: cancelState is AppointmentActionInProgress
                  ? _StaffAppointmentDialogProgress(
                      label: LocaleKeys.staffAppointmentDialog_cancelAction
                          .translate(),
                    )
                  : Text(
                      LocaleKeys.staffAppointmentDialog_cancelAction
                          .translate(),
                    ),
            ),
        ],
      );
    }
    return const SizedBox.shrink();
  }

  Iterable<String> get _hints => offers.map((offer) => offer.hint).nonNulls;

  StaffAppointmentActionOffer? _offerFor(AppointmentAction action) {
    return offers.where((offer) => offer.action == action).firstOrNull;
  }

  Future<void> _reject(BuildContext context) async {
    final confirmation = await AppointmentReasonDialog(
      title: LocaleKeys.staffRequests_rejectTitle.translate(),
      subtitle:
          '${appointment.displayPatientName} · ${appointment.scheduleAndServiceLabel}',
      confirmLabel: LocaleKeys.staffRequests_reject.translate(),
    ).show(context);
    if (confirmation == null || !context.mounted) return;
    await context.performAsStaff(
      context.read<AppointmentRejectCubit>(),
      appointment,
      reason: confirmation.reason,
    );
  }

  Future<void> _cancel(BuildContext context) async {
    final confirmation = await AppointmentReasonDialog(
      title: LocaleKeys.staffAppointmentDialog_cancelTitle.translate(),
      subtitle:
          '${appointment.displayPatientName} · ${appointment.scheduleAndServiceLabel}',
      confirmLabel: LocaleKeys.staffAppointmentDialog_cancel.translate(),
    ).show(context);
    if (confirmation == null || !context.mounted) return;
    await context.performAsStaff(
      context.read<AppointmentStaffCancelCubit>(),
      appointment,
      reason: confirmation.reason,
    );
  }
}
