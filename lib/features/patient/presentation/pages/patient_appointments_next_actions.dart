part of 'patient_appointments_page.dart';

/// Cancel (when the domain allows it) and details actions of the next card.
final class _PatientAppointmentsNextActions extends StatelessWidget {
  const _PatientAppointmentsNextActions({required this.entry});

  final PatientAppointmentEntry entry;

  @override
  Widget build(BuildContext context) {
    final onPrimaryContainer = context.colorScheme.onPrimaryContainer;
    return Wrap(
      spacing: AppSizes.s8,
      runSpacing: AppSizes.s8,
      alignment: WrapAlignment.end,
      children: [
        if (entry.canCancel)
          BlocBuilder<PatientAppointmentCancelCubit, AppointmentActionState>(
            builder: (context, state) {
              return OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: onPrimaryContainer,
                  side: BorderSide(color: onPrimaryContainer),
                ),
                onPressed: state is AppointmentActionInProgress
                    ? null
                    : () => context.requestAppointmentCancel(entry),
                child: Text(LocaleKeys.patient_appointments_cancel.translate()),
              );
            },
          ),
        FilledButton(
          onPressed: () {
            showDialog<void>(
              context: context,
              builder: (_) => _PatientAppointmentsDetailsDialog(
                appointmentId: entry.appointment.id,
                initialEntry: entry,
                appointmentsCubit: context.read<PatientAppointmentsCubit>(),
                catalogCubit: context.read<PatientCatalogCubit>(),
              ),
            );
          },
          child: Text(LocaleKeys.patient_appointments_details.translate()),
        ),
      ],
    );
  }
}
