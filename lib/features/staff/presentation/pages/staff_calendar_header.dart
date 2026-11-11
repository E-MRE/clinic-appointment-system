part of 'staff_calendar_page.dart';

/// Calendar page header displaying localized range title, count subtitle, and controls.
final class _StaffCalendarHeader extends StatelessWidget {
  const _StaffCalendarHeader();

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.screenSize.isDesktop;
    final calendarState = context.watch<StaffCalendarCubit>().state;
    final effectiveView = isDesktop
        ? calendarState.view
        : StaffCalendarView.day;
    final visibleDates = isDesktop
        ? calendarState.visibleDates
        : [calendarState.anchor];

    final appointmentsState = context.watch<StaffAppointmentsCubit>().state;
    final workspaceState = context.watch<StaffWorkspaceCubit>().state;

    final String title;
    final String? subtitle;

    if (appointmentsState is StaffAppointmentsLoaded &&
        workspaceState is StaffWorkspaceLoaded) {
      final clock = AppDependency.injector.get<Clock>();
      final layout = StaffCalendarLayout(
        visibleDates: visibleDates,
        appointments: appointmentsState.appointments,
        availability: workspaceState.workspace.availability,
        branchHours: workspaceState.workspace.branch.workingHours,
        now: clock.now(),
      );

      title = LocaleKeys.staffCalendar_headerTitle.translate(
        args: [layout.headerTitle],
      );

      if (effectiveView == StaffCalendarView.week) {
        subtitle = LocaleKeys.staffCalendar_subtitleWeek.translate(
          args: [
            layout.weekAppointmentCount.toString(),
            appointmentsState.pendingRequests.length.toString(),
          ],
        );
      } else {
        subtitle = LocaleKeys.staffCalendar_subtitleDay.translate(
          args: [layout.weekAppointmentCount.toString()],
        );
      }
    } else {
      title = LocaleKeys.staffCalendar_title.translate();
      subtitle = null;
    }

    if (isDesktop) {
      return PageHeader(
        title: title,
        subtitle: subtitle,
        actions: const _StaffCalendarHeaderActions(showsViewToggle: true),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(title: title, subtitle: subtitle),
        const EmptySize.s8Height(),
        const _StaffCalendarHeaderActions(showsViewToggle: false),
      ],
    );
  }
}
