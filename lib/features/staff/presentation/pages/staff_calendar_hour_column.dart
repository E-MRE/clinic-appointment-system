part of 'staff_calendar_page.dart';

/// The leftmost column of the calendar displaying hour marks.
final class _StaffCalendarHourColumn extends StatelessWidget {
  const _StaffCalendarHourColumn({
    required this.startHour,
    required this.endHour,
    required this.hourHeight,
  });

  final int startHour;
  final int endHour;
  final double hourHeight;

  /// Vertical offset centering the hour label on its horizontal grid line.
  static const double _labelCenterOffset = 8;

  /// Width to zero-pad the single-digit hour component.
  static const int _clockComponentWidth = 2;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.staffCalendarHourColumnWidth,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(
            color: context.colorScheme.outlineVariant,
            width: AppSizes.borderThin,
          ),
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          for (int hour = startHour; hour <= endHour; hour++)
            Positioned(
              top: (hour - startHour) * hourHeight - _labelCenterOffset,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.center,
                child: AppText.badge(
                  '${hour.toString().padLeft(_clockComponentWidth, '0')}:00',
                  tone: TextTone.muted,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
