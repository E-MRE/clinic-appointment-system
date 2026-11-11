part of 'staff_appointment_dialog.dart';

/// Places an optional muted lifecycle hint below its action button.
final class _StaffAppointmentDialogActionButton extends StatelessWidget {
  const _StaffAppointmentDialogActionButton({
    required this.button,
    required this.hint,
  });

  final Widget button;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    final hintText = hint;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.s4,
      children: [
        button,
        if (hintText != null) AppText.caption(hintText, tone: TextTone.muted),
      ],
    );
  }
}
