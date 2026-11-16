part of 'staff_calendar_page.dart';

/// The hour labels and day columns that form the scrollable calendar row.
final class _StaffCalendarGridContentRow extends StatelessWidget {
  const _StaffCalendarGridContentRow({
    required this.layout,
    required this.today,
    required this.totalHeight,
  });

  final StaffCalendarLayout layout;
  final CalendarDate today;
  final double totalHeight;

  /// First day index included in the grid.
  int get _firstIndex => 0;

  /// Offset used to identify the final day column.
  int get _lastIndexOffset => 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _StaffCalendarHourColumn(
          startHour: layout.startHour,
          endHour: layout.endHour,
          hourHeight: AppSizes.staffCalendarHourHeight,
        ),
        for (int index = _firstIndex; index < layout.days.length; index++)
          Expanded(
            child: _StaffCalendarDayColumn(
              day: layout.days[index],
              layout: layout,
              today: today,
              totalHeight: totalHeight,
              hourHeight: AppSizes.staffCalendarHourHeight,
              showsRightBorder: index < layout.days.length - _lastIndexOffset,
            ),
          ),
      ],
    );
  }
}
