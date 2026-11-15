part of 'staff_calendar_page.dart';

/// A calendar day header with its date, appointment count, and optional border.
final class _StaffCalendarGridDayHeaderCell extends StatelessWidget {
  const _StaffCalendarGridDayHeaderCell({
    required this.day,
    required this.today,
    required this.showsRightBorder,
  });

  final StaffCalendarDay day;
  final CalendarDate today;
  final bool showsRightBorder;

  @override
  Widget build(BuildContext context) {
    final isToday = day.date == today;
    final outlineColor = context.colorScheme.outlineVariant;

    return Container(
      padding: const AppPadding.horizontalSm(),
      decoration: BoxDecoration(
        border: showsRightBorder
            ? Border(
                right: BorderSide(
                  color: outlineColor,
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
