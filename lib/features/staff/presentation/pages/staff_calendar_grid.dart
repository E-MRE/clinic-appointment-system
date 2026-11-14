part of 'staff_calendar_page.dart';

/// The scrollable calendar grid for the layout calculated by the calendar cubit.
final class _StaffCalendarGrid extends StatelessWidget {
  const _StaffCalendarGrid({required this.layout});

  final StaffCalendarLayout layout;

  int get _firstIndex => 0;

  int get _lastIndexOffset => 1;

  @override
  Widget build(BuildContext context) {
    final today = CalendarDate.fromDateTime(layout.now);
    final totalHeight =
        (layout.endHour - layout.startHour) * AppSizes.staffCalendarHourHeight;

    return Container(
      decoration: _buildDecoration(context),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StaffCalendarGridHeader(layout: layout, today: today),
          Divider(
            height: AppSizes.borderThin,
            thickness: AppSizes.borderThin,
            color: context.colorScheme.outlineVariant,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: SizedBox(
                height: totalHeight,
                child: _buildContentRow(layout, today, totalHeight),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Row _buildContentRow(
    StaffCalendarLayout layout,
    CalendarDate today,
    double totalHeight,
  ) {
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

  BoxDecoration _buildDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.colorScheme.surface,
      borderRadius: const AppRadius.medium(),
      border: Border.all(
        color: context.colorScheme.outlineVariant,
        width: AppSizes.borderThin,
      ),
    );
  }
}
