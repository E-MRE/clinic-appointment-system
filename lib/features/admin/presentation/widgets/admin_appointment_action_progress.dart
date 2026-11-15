part of 'admin_appointment_row_actions.dart';

/// Compact in-row progress label for a running appointment action.
final class _AdminAppointmentActionProgress extends StatelessWidget {
  const _AdminAppointmentActionProgress({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSizes.s8,
      children: [
        const SizedBox.square(
          dimension: AppSizes.s16,
          child: CircularProgressIndicator(strokeWidth: AppSizes.s2),
        ),
        AppText.label(label),
      ],
    );
  }
}
