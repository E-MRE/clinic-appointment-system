part of 'staff_appointment_dialog.dart';

/// Renders the patient's identity, appointment details and available actions.
final class _StaffAppointmentDialogContent extends StatelessWidget {
  const _StaffAppointmentDialogContent({required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    final workspaceState = context.watch<StaffWorkspaceCubit>().state;

    final location = _getLocation(workspaceState);
    final reason = appointment.statusReason;

    final offers = StaffAppointmentActionOffers(
      appointment: appointment,
      actor: context.staffAppointmentActor,
      at: AppDependency.injector.get<Clock>().now(),
    ).offers;

    return SizedBox(
      width: AppSizes.formDialogMaxWidth,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: AppSizes.s20,
          children: [
            StaffPatientHeader(appointment: appointment),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: AppointmentStatusBadge(status: appointment.status),
            ),
            StaffAppointmentDetailGrid(
              appointment: appointment,
              location: location,
            ),
            if (reason != null && reason.trim().isNotEmpty)
              AppDefinitionRow(
                label: LocaleKeys.staffAppointmentDialog_statusReason.tr(),
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

  String _getLocation(StaffWorkspaceState workspaceState) {
    if (workspaceState is StaffWorkspaceLoaded) {
      final workspace = workspaceState.workspace;
      return '${workspace.branch.name} · ${workspace.department.name}';
    }

    return LocaleKeys.common_notAvailable.translate();
  }
}
