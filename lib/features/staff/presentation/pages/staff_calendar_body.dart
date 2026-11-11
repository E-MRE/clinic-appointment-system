part of 'staff_calendar_page.dart';

/// Switches between loading, failure, and the staff calendar grid.
final class _StaffCalendarBody extends StatelessWidget {
  const _StaffCalendarBody();

  @override
  Widget build(BuildContext context) {
    final appointmentsState = context.watch<StaffAppointmentsCubit>().state;
    final workspaceState = context.watch<StaffWorkspaceCubit>().state;

    if (appointmentsState is StaffAppointmentsFailure) {
      return _StaffCalendarFailure(
        message: appointmentsState.errorCode.message,
      );
    }
    if (workspaceState is StaffWorkspaceFailure) {
      return _StaffCalendarFailure(
        message: LocaleKeys.staffCalendar_failureTitle.translate(),
      );
    }

    if (appointmentsState is! StaffAppointmentsLoaded ||
        workspaceState is! StaffWorkspaceLoaded) {
      return LoadingState(
        variant: LoadingStateVariant.skeletonList,
        label: LocaleKeys.staffCalendar_loading.translate(),
      );
    }

    final isDesktop = context.screenSize.isDesktop;
    final calendarState = context.watch<StaffCalendarCubit>().state;
    final visibleDates = isDesktop
        ? calendarState.visibleDates
        : [calendarState.anchor];

    return _StaffCalendarGrid(
      visibleDates: visibleDates,
      appointments: appointmentsState.appointments,
      availability: workspaceState.workspace.availability,
      branchHours: workspaceState.workspace.branch.workingHours,
    );
  }
}
