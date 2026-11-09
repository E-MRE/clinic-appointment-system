part of 'patient_appointments_page.dart';

/// A muted term above its value in the details dialog.
final class _PatientAppointmentsDetailRow extends StatelessWidget {
  const _PatientAppointmentsDetailRow({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.s4,
      children: [
        AppText.caption(label, tone: TextTone.muted),
        child,
      ],
    );
  }
}
