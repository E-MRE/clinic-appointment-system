part of 'staff_appointment_dialog.dart';

/// Lines up the action buttons evenly at the end and lists the hints of
/// temporarily disabled actions below them.
final class _StaffAppointmentDialogActionBar extends StatelessWidget {
  const _StaffAppointmentDialogActionBar({
    required this.buttons,
    required this.hints,
  });

  final List<Widget> buttons;
  final Iterable<String> hints;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      spacing: AppSizes.s8,
      children: [
        Wrap(
          alignment: WrapAlignment.end,
          spacing: AppSizes.s12,
          runSpacing: AppSizes.s8,
          children: buttons,
        ),
        for (final hint in hints)
          AppText.caption(hint, tone: TextTone.muted, textAlign: TextAlign.end),
      ],
    );
  }
}
