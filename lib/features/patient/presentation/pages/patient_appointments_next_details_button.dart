part of 'patient_appointments_page.dart';

/// Opens the selected appointment's detail dialog.
final class _PatientAppointmentsNextDetailsButton extends StatelessWidget {
  const _PatientAppointmentsNextDetailsButton({required this.entry});

  final PatientAppointmentEntry entry;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (_) => _PatientAppointmentsDetailsDialog(
            appointmentId: entry.appointment.id,
            initialEntry: entry,
            appointmentsCubit: context.read<PatientAppointmentsCubit>(),
            catalogCubit: context.read<ClinicCatalogCubit>(),
          ),
        );
      },
      child: AppText.label(
        LocaleKeys.patient_appointments_details.translate(),
        tone: TextTone.onPrimary,
      ),
    );
  }
}
