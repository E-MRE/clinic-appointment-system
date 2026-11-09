part of 'patient_appointments_page.dart';

/// Appointments of the selected tab with date, service, staff and status.
final class _PatientAppointmentsTable extends StatelessWidget {
  const _PatientAppointmentsTable({required this.overview, required this.rows});

  final PatientAppointmentsOverview overview;
  final List<PatientAppointmentEntry> rows;

  @override
  Widget build(BuildContext context) {
    return AppDataTable<PatientAppointmentEntry>(
      rows: rows,
      minWidth: AppSizes.patientAppointmentsTableMinWidth,
      density: AppTableDensity.compact,
      header: _PatientAppointmentsTabs(overview: overview),
      columns: _columns,
    );
  }

  List<AppTableColumn<PatientAppointmentEntry>> get _columns {
    return [
      AppTableColumn<PatientAppointmentEntry>(
        label: LocaleKeys.patient_appointments_columns_date.translate(),
        noWrap: true,
        cellBuilder: (_, entry) => AppText.bodyStrong(entry.dateTimeLabel),
      ),
      AppTableColumn<PatientAppointmentEntry>(
        label: LocaleKeys.patient_appointments_columns_service.translate(),
        cellBuilder: (_, entry) {
          return _PatientAppointmentsServiceCell(entry: entry);
        },
      ),
      AppTableColumn<PatientAppointmentEntry>(
        label: LocaleKeys.patient_appointments_columns_staff.translate(),
        cellBuilder: (_, entry) {
          return AppText.body(entry.staffName, tone: TextTone.muted);
        },
      ),
      AppTableColumn<PatientAppointmentEntry>(
        label: LocaleKeys.patient_appointments_columns_status.translate(),
        noWrap: true,
        cellBuilder: (_, entry) {
          return AppointmentStatusBadge(status: entry.appointment.status);
        },
      ),
      AppTableColumn<PatientAppointmentEntry>(
        label: '',
        semanticsLabel: LocaleKeys.patient_appointments_columns_actions
            .translate(),
        alignment: AppTableAlignment.end,
        cellBuilder: (context, entry) {
          return IconButton(
            tooltip: LocaleKeys.patient_appointments_detailsTooltip.translate(),
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (_) => _PatientAppointmentsDetailsDialog(
                  appointmentId: entry.appointment.id,
                  initialEntry: entry,
                  appointmentsCubit: context.read<PatientAppointmentsCubit>(),
                  catalogCubit: context.read<PatientCatalogCubit>(),
                ),
              );
            },
          );
        },
      ),
    ];
  }
}
