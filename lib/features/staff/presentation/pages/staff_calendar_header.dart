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

    final (title, subtitle) = _getTitles(
      appointmentsState: appointmentsState,
      workspaceState: workspaceState,
      visibleDates: visibleDates,
      effectiveView: effectiveView,
    );

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

  (String title, String? subtitle) _getTitles({
    required StaffAppointmentsState appointmentsState,
    required StaffWorkspaceState workspaceState,
    required List<CalendarDate> visibleDates,
    required StaffCalendarView effectiveView,
  }) {
    if (appointmentsState is StaffAppointmentsLoaded &&
        workspaceState is StaffWorkspaceLoaded) {
      final clock = AppDependency.injector.get<Clock>();
      final layout = const StaffCalendarLayoutFactory().create(
        visibleDates: visibleDates,
        appointments: appointmentsState.appointments,
        availability: workspaceState.workspace.availability,
        branchHours: workspaceState.workspace.branch.workingHours,
        now: clock.now(),
      );

      final title = LocaleKeys.staffCalendar_headerTitle.translate(
        args: [layout.headerTitle],
      );

      final String subtitle = _getSubtitle(
        effectiveView,
        layout,
        appointmentsState,
      );

      return (title, subtitle);
    }

    return (LocaleKeys.staffCalendar_title.translate(), null);
  }

  String _getSubtitle(
    StaffCalendarView effectiveView,
    StaffCalendarLayout layout,
    StaffAppointmentsLoaded appointmentsState,
  ) {
    if (effectiveView == StaffCalendarView.week) {
      return LocaleKeys.staffCalendar_subtitleWeek.translate(
        args: [
          layout.weekAppointmentCount.toString(),
          appointmentsState.pendingRequests.length.toString(),
        ],
      );
    }

    return LocaleKeys.staffCalendar_subtitleDay.translate(
      args: [layout.weekAppointmentCount.toString()],
    );
  }
}
