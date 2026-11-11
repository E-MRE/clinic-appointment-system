part of 'staff_appointment_dialog.dart';

/// Renders the patient's identity, appointment details and available actions.
final class _StaffAppointmentDialogContent extends StatelessWidget {
  const _StaffAppointmentDialogContent({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    final workspaceState = context.watch<StaffWorkspaceCubit>().state;
    final workspace = workspaceState is StaffWorkspaceLoaded
        ? workspaceState.workspace
        : null;
    final String location;
    if (workspace != null) {
      location = '${workspace.branch.name} · ${workspace.department.name}';
    } else {
      location = LocaleKeys.common_notAvailable.translate();
    }
    final actor = context.staffAppointmentActor;
    final offers = StaffAppointmentActionOffers(
      appointment: appointment,
      actor: actor,
      at: AppDependency.injector.get<Clock>().now(),
    ).offers;
    final reason = appointment.statusReason;

    return SizedBox(
      width: AppSizes.formDialogMaxWidth,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: AppSizes.s20,
          children: [
            StaffPatientHeader(appointment: appointment),
            AppointmentStatusBadge(status: appointment.status),
            StaffAppointmentDetailGrid(
              appointment: appointment,
              location: location,
            ),
            if (reason != null && reason.trim().isNotEmpty)
              AppDefinitionRow(
                label: LocaleKeys.staffAppointmentDialog_statusReason
                    .translate(),
                child: AppText.body(reason),
              ),
            const _StaffAppointmentDialogError(),
            if (offers.isNotEmpty) ...[
              const Divider(),
              _StaffAppointmentDialogActions(
                appointment: appointment,
                offers: offers,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
