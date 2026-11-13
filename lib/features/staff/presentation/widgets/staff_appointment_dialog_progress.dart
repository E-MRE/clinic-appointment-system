part of 'staff_appointment_dialog.dart';

/// Announces an in-flight lifecycle action beside its progress indicator.
final class _StaffAppointmentDialogProgress extends StatelessWidget {
  const _StaffAppointmentDialogProgress({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: const SizedBox.square(
        dimension: AppSizes.s20,
        child: CircularProgressIndicator(strokeWidth: AppSizes.s4),
      ),
    );
  }
}
