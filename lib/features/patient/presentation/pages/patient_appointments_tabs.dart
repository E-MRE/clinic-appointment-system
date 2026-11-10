part of 'patient_appointments_page.dart';

/// Tümü, Yaklaşan and Geçmiş tabs with their counts.
final class _PatientAppointmentsTabs extends StatelessWidget {
  const _PatientAppointmentsTabs({required this.overview});

  final PatientAppointmentsOverview overview;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PatientAppointmentsTabCubit, PatientAppointmentsTab>(
      builder: (context, selected) {
        return AppTabBar<PatientAppointmentsTab>(
          choices: [
            for (final tab in PatientAppointmentsTab.values)
              AppChoice<PatientAppointmentsTab>(
                value: tab,
                label: tab.label(overview),
              ),
          ],
          selected: selected,
          onSelected: context.read<PatientAppointmentsTabCubit>().select,
        );
      },
    );
  }
}
