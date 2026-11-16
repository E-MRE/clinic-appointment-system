part of 'staff_calendar_page.dart';

/// Pinned top row of the calendar grid displaying weekday, date, and appointment counts.
final class _StaffCalendarGridHeader extends StatelessWidget {
  const _StaffCalendarGridHeader({required this.layout, required this.today});

  final StaffCalendarLayout layout;
  final CalendarDate today;

  int get _lastIndexOffset => 1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.staffCalendarHeaderHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: AppSizes.staffCalendarHourColumnWidth,
            decoration: _buildDecoration(context),
          ),
          for (int i = 0; i < layout.days.length; i++)
            Expanded(
              child: _StaffCalendarGridDayHeaderCell(
                day: layout.days[i],
                today: today,
                showsRightBorder: i < layout.days.length - _lastIndexOffset,
              ),
            ),
        ],
      ),
    );
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    return BoxDecoration(
      border: Border(
        right: BorderSide(
          color: context.colorScheme.outlineVariant,
          width: AppSizes.borderThin,
        ),
      ),
    );
  }
}
