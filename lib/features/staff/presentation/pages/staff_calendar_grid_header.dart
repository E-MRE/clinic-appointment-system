part of 'staff_calendar_page.dart';

/// Pinned top row of the calendar grid displaying weekday, date, and appointment counts.
final class _StaffCalendarGridHeader extends StatelessWidget {
  const _StaffCalendarGridHeader({required this.layout, required this.today});

  final StaffCalendarLayout layout;
  final CalendarDate today;

  static const int _lastIndexOffset = 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.staffCalendarHeaderHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: AppSizes.staffCalendarHourColumnWidth,
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: context.colorScheme.outlineVariant,
                  width: AppSizes.borderThin,
                ),
              ),
            ),
          ),
          for (int i = 0; i < layout.days.length; i++)
            Expanded(
              child: _buildDayHeaderCell(
                context,
                day: layout.days[i],
                showsRightBorder: i < layout.days.length - _lastIndexOffset,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDayHeaderCell(
    BuildContext context, {
    required StaffCalendarDay day,
    required bool showsRightBorder,
  }) {
    final isToday = day.date == today;

    return Container(
      padding: const AppPadding.horizontalSm(),
      decoration: BoxDecoration(
        border: showsRightBorder
            ? Border(
                right: BorderSide(
                  color: context.colorScheme.outlineVariant,
                  width: AppSizes.borderThin,
                ),
              )
            : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText.label(
                day.date.weekday.shortLabel,
                tone: isToday ? TextTone.primary : TextTone.muted,
              ),
              const EmptySize.s4Width(),
              AppText.cardTitle(
                '${day.date.day}',
                tone: isToday ? TextTone.primary : TextTone.normal,
              ),
            ],
          ),
          if (!day.isClosed)
            AppText.caption(
              LocaleKeys.staffCalendar_dayHeader_appointmentCount.translate(
                args: ['${day.appointmentCount}'],
              ),
              tone: TextTone.muted,
            ),
        ],
      ),
    );
  }
}
