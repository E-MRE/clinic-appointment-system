part of 'admin_appointments_page.dart';

/// Builds the horizontally scrollable result table from the current page rows.
final class _AdminAppointmentsTable extends StatelessWidget {
  const _AdminAppointmentsTable({
    required this.clock,
    required this.state,
    required this.catalog,
    required this.actor,
    required this.searchController,
  });

  final Clock clock;
  final AdminAppointmentsLoaded state;
  final ClinicCatalog catalog;
  final AdminAppointmentActor actor;
  final TextEditingController searchController;

  int get _singleLine => 1;

  @override
  Widget build(BuildContext context) {
    final now = clock.now();
    final rows = [
      for (final appointment in state.currentPageAppointments)
        AdminAppointmentRowPresentation(
          appointment: appointment,
          catalog: catalog,
          actor: actor,
          at: now,
        ),
    ];
    final header = _AdminAppointmentsTableHeader(
      state: state,
      searchController: searchController,
    );
    final footer = _AdminAppointmentsTableFooter(state: state);
    if (rows.isEmpty) {
      return _AdminAppointmentsEmptyTable(header: header, footer: footer);
    }
    return AppDataTable<AdminAppointmentRowPresentation>(
      rows: rows,
      minWidth: AdminLayoutConstants.appointmentsTableMinWidth,
      density: AppTableDensity.regular,
      rowVerticalPadding: AppSizes.s8,
      header: header,
      footer: footer,
      columns: _columns,
    );
  }

  List<AppTableColumn<AdminAppointmentRowPresentation>> get _columns {
    return [
      AppTableColumn<AdminAppointmentRowPresentation>(
        label: LocaleKeys.admin_appointmentsPage_columnDate.translate(),
        noWrap: true,
        maxWidth: AdminLayoutConstants.appointmentDateColumnMaxWidth,
        cellBuilder: (_, row) => AppText.bodyStrong(
          row.dateTimeLabel,
          maxLines: _singleLine,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      AppTableColumn<AdminAppointmentRowPresentation>(
        label: LocaleKeys.admin_appointmentsPage_columnPatient.translate(),
        noWrap: true,
        maxWidth: AdminLayoutConstants.appointmentPatientColumnMaxWidth,
        cellBuilder: (_, row) => AppText.body(
          row.appointment.patientName,
          maxLines: _singleLine,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      AppTableColumn<AdminAppointmentRowPresentation>(
        label: LocaleKeys.admin_appointmentsPage_columnService.translate(),
        noWrap: true,
        maxWidth: AdminLayoutConstants.appointmentServiceColumnMaxWidth,
        cellBuilder: (_, row) => AppText.body(
          row.appointment.serviceName,
          maxLines: _singleLine,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      AppTableColumn<AdminAppointmentRowPresentation>(
        label: LocaleKeys.admin_appointmentsPage_columnStaff.translate(),
        noWrap: true,
        maxWidth: AdminLayoutConstants.appointmentStaffColumnMaxWidth,
        cellBuilder: (_, row) => AppText.body(
          row.staffName,
          tone: TextTone.muted,
          maxLines: _singleLine,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      AppTableColumn<AdminAppointmentRowPresentation>(
        label: LocaleKeys.admin_appointmentsPage_columnLocation.translate(),
        noWrap: true,
        maxWidth: AdminLayoutConstants.appointmentLocationColumnMaxWidth,
        cellBuilder: (_, row) => AppText.body(
          row.departmentBranchLabel,
          tone: TextTone.muted,
          maxLines: _singleLine,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      AppTableColumn<AdminAppointmentRowPresentation>(
        label: LocaleKeys.admin_appointmentsPage_columnStatus.translate(),
        noWrap: true,
        maxWidth: AdminLayoutConstants.appointmentStatusColumnMaxWidth,
        cellBuilder: (_, row) {
          return AppointmentStatusBadge(status: row.appointment.status);
        },
      ),
      AppTableColumn<AdminAppointmentRowPresentation>(
        label: LocaleKeys.admin_appointmentsPage_columnActions.translate(),
        alignment: AppTableAlignment.end,
        noWrap: true,
        maxWidth: AdminLayoutConstants.appointmentActionsColumnMaxWidth,
        cellBuilder: (_, row) {
          return AdminAppointmentRowActions(
            appointment: row.appointment,
            offeredActions: row.actions,
          );
        },
      ),
    ];
  }
}
