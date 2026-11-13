part of 'staff_requests_page.dart';

/// Detail panel for the selected request.
final class _StaffRequestsDetailPanel extends StatelessWidget {
  const _StaffRequestsDetailPanel({required this.request});

  final Appointment request;

  @override
  Widget build(BuildContext context) {
    final appointments = context
        .watch<StaffAppointmentsCubit>()
        .state
        .appointments;

    final workspaceState = context.watch<StaffWorkspaceCubit>().state;
    final workspace = workspaceState is StaffWorkspaceLoaded
        ? workspaceState.workspace
        : null;

    final service = workspace?.serviceById(request.serviceId);
    final String location = _getLocation(workspaceState);
    final history = StaffPatientHistory.fromAppointments(
      patientId: request.patientId,
      appointments: appointments,
    );

    return AppSurface(
      padding: AppSurfacePadding.comfortable,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: AppSizes.s20,
          children: [
            StaffPatientHeader(
              appointment: request,
              subtitle: request.requestedAgoLabel(
                AppDependency.injector.get<Clock>().now(),
              ),
            ),
            StaffAppointmentDetailGrid(
              appointment: request,
              location: location,
            ),
            if (workspace != null && service != null)
              _StaffRequestDetailRuleChecks(
                request: request,
                workspace: workspace,
                service: service,
                appointments: appointments,
              ),
            if (history.hasHistory)
              _StaffRequestDetailPatientHistory(history: history),
            const Divider(),
            _StaffRequestsDetailActions(request: request),
          ],
        ),
      ),
    );
  }

  String _getLocation(StaffWorkspaceState workspaceState) {
    if (workspaceState is StaffWorkspaceLoaded) {
      return '${workspaceState.workspace.branch.name} · ${workspaceState.workspace.department.name}';
    }

    return LocaleKeys.common_notAvailable.translate();
  }
}
