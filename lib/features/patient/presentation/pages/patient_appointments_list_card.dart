part of 'patient_appointments_page.dart';

/// Tabbed appointments table, or the tab's empty message.
final class _PatientAppointmentsListCard extends StatelessWidget {
  const _PatientAppointmentsListCard({required this.overview});

  final PatientAppointmentsOverview overview;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientAppointmentsTabCubit, PatientAppointmentsTab>(
      builder: (context, tab) {
        final rows = tab.select(overview);
        if (rows.isEmpty) {
          return AppSurface(
            padding: AppSurfacePadding.none,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _PatientAppointmentsTabs(overview: overview),
                const Divider(height: AppSizes.borderThin),
                AppMutedMessage(message: tab.emptyMessage),
              ],
            ),
          );
        }
        return _PatientAppointmentsTable(overview: overview, rows: rows);
      },
    );
  }
}
