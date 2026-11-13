part of 'staff_calendar_page.dart';

/// One day column displaying hour grid lines, availability, appointments, and now line.
final class _StaffCalendarDayColumn extends StatelessWidget {
  const _StaffCalendarDayColumn({
    required this.day,
    required this.layout,
    required this.today,
    required this.totalHeight,
    required this.hourHeight,
    required this.showsRightBorder,
  });

  final StaffCalendarDay day;
  final StaffCalendarLayout layout;
  final CalendarDate today;
  final double totalHeight;
  final double hourHeight;
  final bool showsRightBorder;

  int get _nextHourOffset => 1;

  double _rangeTop(TimeRange range) =>
      layout.fractionOf(range.start) * totalHeight;

  double _rangeHeight(TimeRange range) =>
      layout.heightFractionOf(range) * totalHeight;

  @override
  Widget build(BuildContext context) {
    final nowFraction = day.date == today ? layout.nowFraction : null;

    final border = Border(
      right: BorderSide(
        color: context.colorScheme.outlineVariant,
        width: AppSizes.borderThin,
      ),
    );

    return Container(
      decoration: BoxDecoration(border: showsRightBorder ? border : null),
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          for (
            int hour = layout.startHour + _nextHourOffset;
            hour <= layout.endHour;
            hour++
          )
            Positioned(
              top: (hour - layout.startHour) * hourHeight,
              left: 0,
              right: 0,
              child: Divider(
                height: AppSizes.borderThin,
                thickness: AppSizes.borderThin,
                color: context.colorScheme.outlineVariant,
              ),
            ),
          if (day.isClosed)
            Center(
              child: AppText.body(
                LocaleKeys.staffCalendar_branchClosed.translate(),
                tone: TextTone.muted,
              ),
            )
          else ...[
            for (final band in day.availabilityBands)
              Positioned(
                top: _rangeTop(band),
                height: _rangeHeight(band),
                left: 0,
                right: 0,
                child: Container(
                  color: context.colorScheme.surfaceContainerLow,
                ),
              ),
            for (final appointment in day.appointments)
              Positioned(
                top: _rangeTop(appointment.range),
                height: _rangeHeight(appointment.range),
                left: AppSizes.s4,
                right: AppSizes.s4,
                child: _StaffCalendarAppointmentBlock(appointment: appointment),
              ),
          ],
          if (nowFraction != null)
            Positioned.fill(
              child: _StaffCalendarNowLine(
                key: const WidgetKey.staffCalendarNowLine(),
                nowFraction: nowFraction,
                totalHeight: totalHeight,
              ),
            ),
        ],
      ),
    );
  }
}
