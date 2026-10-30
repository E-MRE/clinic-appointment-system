part of 'component_preview_page.dart';

/// Demonstrates appointment rows at one table density.
final class _PreviewAppointmentsTable extends StatelessWidget {
  const _PreviewAppointmentsTable({required this.density});

  final AppTableDensity density;

  @override
  Widget build(BuildContext context) {
    return AppDataTable<_PreviewAppointment>(
      rows: _PreviewAppointment.samples,
      minWidth: AppSizes.previewTabletWidth,
      density: density,
      rowVerticalPadding: AppSizes.s8,
      header: _PreviewAppointmentsHeader(density: density),
      columns: _columns,
    );
  }

  List<AppTableColumn<_PreviewAppointment>> get _columns {
    return [
      AppTableColumn(
        label: LocaleKeys.componentPreview_table_date.translate(),
        noWrap: true,
        cellBuilder: (context, row) => AppText.body(
          AppFormatters.formatDateTime(row.dateTime, context: context),
        ),
      ),
      AppTableColumn(
        label: LocaleKeys.componentPreview_table_patient.translate(),
        cellBuilder: (context, row) =>
            _PreviewAppointmentPatientCell(appointment: row),
      ),
      AppTableColumn(
        label: LocaleKeys.componentPreview_table_service.translate(),
        cellBuilder: (context, row) => AppText.body(row.serviceKey.translate()),
      ),
      AppTableColumn(
        label: LocaleKeys.componentPreview_table_staff.translate(),
        cellBuilder: (context, row) =>
            AppText.body(row.staffName, tone: TextTone.muted),
      ),
      AppTableColumn(
        label: LocaleKeys.componentPreview_table_status.translate(),
        cellBuilder: (context, row) => StatusBadge(
          label: LocaleKeys.appointment_status_approved.translate(),
          variant: StatusBadgeVariant.approved,
        ),
      ),
      AppTableColumn(
        label: '',
        semanticsLabel: LocaleKeys.componentPreview_table_actions.translate(),
        alignment: AppTableAlignment.end,
        cellBuilder: (context, row) => IconButton(
          onPressed: () {},
          tooltip: LocaleKeys.common_edit.translate(),
          icon: const Icon(Icons.edit_outlined),
        ),
      ),
    ];
  }
}
