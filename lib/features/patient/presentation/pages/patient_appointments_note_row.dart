part of 'patient_appointments_page.dart';

/// One preparation note: kind icon, service and date, note text.
final class _PatientAppointmentsNoteRow extends StatelessWidget {
  const _PatientAppointmentsNoteRow({required this.note});

  final PatientPreparationNote note;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.s12,
      children: [
        AppIconTile(
          icon: note.entry.kindIcon,
          variant: AppIconTileVariant.tertiary,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.bodyStrong(note.entry.noteHeading),
              AppText.body(note.note, tone: TextTone.muted),
            ],
          ),
        ),
      ],
    );
  }
}
