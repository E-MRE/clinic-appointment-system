part of 'staff_calendar_page.dart';

/// Content layout arranging the header, legend, and scrollable body grid.
final class _StaffCalendarViewContent extends StatelessWidget {
  const _StaffCalendarViewContent();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StaffAppointmentsCubit, StaffAppointmentsState>(
          listener: _onAppointmentsChanged,
        ),
        BlocListener<StaffWorkspaceCubit, StaffWorkspaceState>(
          listener: _onWorkspaceChanged,
        ),
      ],
      child: const AppScaffold(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _StaffCalendarHeader(),
            EmptySize.s12Height(),
            _StaffCalendarLegend(),
            EmptySize.s16Height(),
            Expanded(child: _StaffCalendarBody()),
          ],
        ),
      ),
    );
  }

  void _onAppointmentsChanged(
    BuildContext context,
    StaffAppointmentsState state,
  ) {
    final appointments = state is StaffAppointmentsLoaded
        ? state.appointments
        : null;
    context.read<StaffCalendarCubit>().updateAppointments(appointments);
  }

  void _onWorkspaceChanged(BuildContext context, StaffWorkspaceState state) {
    final workspace = state is StaffWorkspaceLoaded ? state.workspace : null;
    context.read<StaffCalendarCubit>().updateWorkspace(workspace);
  }
}
