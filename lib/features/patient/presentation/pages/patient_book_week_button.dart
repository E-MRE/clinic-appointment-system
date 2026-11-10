part of 'patient_book_page.dart';

/// A circular outlined week navigation button; disabled without [onPressed].
final class _PatientBookWeekButton extends StatelessWidget {
  const _PatientBookWeekButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.outlined(
      tooltip: tooltip,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(
        width: AppSizes.bookingWeekButton,
        height: AppSizes.bookingWeekButton,
      ),
      iconSize: AppSizes.s20,
      icon: Icon(icon),
    );
  }
}
