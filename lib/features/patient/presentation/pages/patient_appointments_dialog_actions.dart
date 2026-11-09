part of 'patient_appointments_page.dart';

/// Close and, when the domain allows it, the destructive cancel action.
final class _PatientAppointmentsDialogActions extends StatelessWidget {
  const _PatientAppointmentsDialogActions({required this.entry});

  final PatientAppointmentEntry entry;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: AppSizes.s8,
      runSpacing: AppSizes.s8,
      children: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(LocaleKeys.patient_appointments_dialog_close.translate()),
        ),
        if (entry.canCancel)
          BlocBuilder<
            PatientAppointmentCancelCubit,
            PatientAppointmentCancelState
          >(
            builder: (context, state) {
              return FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: colors.error,
                  foregroundColor: colors.onError,
                ),
                onPressed: state is PatientAppointmentCancelInProgress
                    ? null
                    : () => context.requestAppointmentCancel(entry),
                child: Text(
                  LocaleKeys.patient_appointments_dialog_cancel.translate(),
                ),
              );
            },
          ),
      ],
    );
  }
}
