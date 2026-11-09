part of 'patient_appointments_page.dart';

/// Preparation notes of upcoming appointments.
final class _PatientAppointmentsNotesCard extends StatelessWidget {
  const _PatientAppointmentsNotesCard({required this.notes});

  final List<PatientPreparationNote> notes;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      padding: AppSurfacePadding.comfortable,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s16,
        children: [
          Semantics(
            header: true,
            child: AppText.cardTitle(
              LocaleKeys.patient_appointments_notesTitle.translate(),
            ),
          ),
          for (final note in notes) _PatientAppointmentsNoteRow(note: note),
        ],
      ),
    );
  }
}
