part of 'staff_calendar_page.dart';

/// Navigation buttons and view toggles displayed in the calendar header.
final class _StaffCalendarHeaderActions extends StatelessWidget {
  const _StaffCalendarHeaderActions({this.showsViewToggle = true});

  final bool showsViewToggle;

  @override
  Widget build(BuildContext context) {
    final calendarCubit = context.read<StaffCalendarCubit>();
    final currentView = context.watch<StaffCalendarCubit>().state.view;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          onPressed: calendarCubit.today,
          child: Text(LocaleKeys.staffCalendar_today.translate()),
        ),
        const EmptySize.s8Width(),
        IconButton.outlined(
          tooltip: LocaleKeys.staffCalendar_previous.translate(),
          onPressed: calendarCubit.previous,
          icon: const Icon(Icons.chevron_left),
        ),
        const EmptySize.s4Width(),
        IconButton.outlined(
          tooltip: LocaleKeys.staffCalendar_next.translate(),
          onPressed: calendarCubit.next,
          icon: const Icon(Icons.chevron_right),
        ),
        if (showsViewToggle) ...[
          const EmptySize.s12Width(),
          SizedBox(
            width: AppSizes.s144,
            child: AppSegmentedControl<StaffCalendarView>(
              choices: [
                AppChoice<StaffCalendarView>(
                  value: StaffCalendarView.day,
                  label: LocaleKeys.staffCalendar_viewDay.translate(),
                ),
                AppChoice<StaffCalendarView>(
                  value: StaffCalendarView.week,
                  label: LocaleKeys.staffCalendar_viewWeek.translate(),
                ),
              ],
              selected: currentView,
              onSelected: (view) {
                if (view == StaffCalendarView.day) {
                  calendarCubit.showDay();
                } else {
                  calendarCubit.showWeek();
                }
              },
            ),
          ),
        ],
      ],
    );
  }
}
