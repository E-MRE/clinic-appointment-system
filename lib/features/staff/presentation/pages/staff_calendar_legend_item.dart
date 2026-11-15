part of 'staff_calendar_page.dart';

/// Single item in the calendar legend pairing a color swatch with a status label.
final class _StaffCalendarLegendItem extends StatelessWidget {
  const _StaffCalendarLegendItem({
    required this.label,
    required this.background,
    this.foreground,
    this.isDashed = false,
  });

  final String label;
  final Color background;
  final Color? foreground;
  final bool isDashed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _StaffCalendarLegendSwatch(
          background: background,
          foreground: foreground,
          isDashed: isDashed,
        ),
        const EmptySize.s8Width(),
        AppText.caption(label, tone: TextTone.muted),
      ],
    );
  }
}
