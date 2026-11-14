part of 'admin_home_page.dart';

/// Builds the pending approval table with shared appointment actions.
final class _AdminHomePendingTable extends StatelessWidget {
  const _AdminHomePendingTable({
    required this.clock,
    required this.summary,
    required this.catalog,
    required this.actor,
  });

  final Clock clock;
  final AdminDashboardSummary summary;
  final ClinicCatalog catalog;
  final AdminAppointmentActor actor;

  @override
  Widget build(BuildContext context) {
    final now = clock.now();
    final rows = [
      for (final appointment in summary.pendingAppointments)
        AdminAppointmentRowPresentation(
          appointment: appointment,
          catalog: catalog,
          actor: actor,
          at: now,
        ),
    ];
    final emptyFooter = rows.isEmpty ? const _AdminHomePendingEmpty() : null;
    return AppDataTable<AdminAppointmentRowPresentation>(
      rows: rows,
      columns: _columns(now),
      minWidth: AdminLayoutConstants.overviewPendingTableMinWidth,
      density: AppTableDensity.regular,
      rowVerticalPadding: AppSizes.s8,
      header: _AdminHomePendingTableHeader(count: summary.pendingCount),
      footer: emptyFooter,
    );
  }

  List<AppTableColumn<AdminAppointmentRowPresentation>> _columns(DateTime now) {
    return [
      AppTableColumn<AdminAppointmentRowPresentation>(
        label: LocaleKeys.admin_appointmentsPage_columnDate.translate(),
        noWrap: true,
        maxWidth: AdminLayoutConstants.overviewPendingDateColumnWidth,
        cellBuilder: (_, row) => AppText.bodyStrong(
          row.dateTimeLabel,
          maxLines: AdminLayoutConstants.overviewMinimumColumnCount,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      AppTableColumn<AdminAppointmentRowPresentation>(
        label: LocaleKeys.admin_appointmentsPage_columnPatient.translate(),
        noWrap: true,
        maxWidth: AdminLayoutConstants.overviewPendingPatientColumnWidth,
        cellBuilder: (_, row) => AppText.bodyStrong(
          row.appointment.patientName,
          maxLines: AdminLayoutConstants.overviewMinimumColumnCount,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      AppTableColumn<AdminAppointmentRowPresentation>(
        label: LocaleKeys.admin_appointmentsPage_columnService.translate(),
        noWrap: true,
        maxWidth: AdminLayoutConstants.overviewPendingServiceColumnWidth,
        cellBuilder: (_, row) => AppText.body(
          row.appointment.serviceName,
          maxLines: AdminLayoutConstants.overviewMinimumColumnCount,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      AppTableColumn<AdminAppointmentRowPresentation>(
        label: LocaleKeys.admin_appointmentsPage_columnStaff.translate(),
        noWrap: true,
        maxWidth: AdminLayoutConstants.overviewPendingStaffColumnWidth,
        cellBuilder: (_, row) => AppText.body(
          row.staffName,
          tone: TextTone.muted,
          maxLines: AdminLayoutConstants.overviewMinimumColumnCount,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      AppTableColumn<AdminAppointmentRowPresentation>(
        label: LocaleKeys.admin_overview_columnRequestAge.translate(),
        noWrap: true,
        maxWidth: AdminLayoutConstants.overviewPendingAgeColumnWidth,
        cellBuilder: (_, row) => AppText.body(
          row.appointment.history.first.at.relativeLabel(now),
          tone: TextTone.muted,
          maxLines: AdminLayoutConstants.overviewMinimumColumnCount,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      AppTableColumn<AdminAppointmentRowPresentation>(
        label: LocaleKeys.admin_appointmentsPage_columnActions.translate(),
        alignment: AppTableAlignment.end,
        noWrap: true,
        maxWidth: AdminLayoutConstants.overviewPendingActionsColumnWidth,
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
