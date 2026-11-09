part of 'patient_appointments_page.dart';

/// Header and the two content columns; one column below desktop width.
final class _PatientAppointmentsContent extends StatelessWidget {
  const _PatientAppointmentsContent({
    required this.firstName,
    required this.overview,
  });

  final String firstName;
  final PatientAppointmentsOverview overview;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSizes.patientContentMaxWidth,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSizes.s24,
            children: [
              PageHeader(
                title: LocaleKeys.patient_appointments_title.translate(),
                subtitle: overview.greeting(firstName),
              ),
              if (context.screenSize.isDesktop)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSizes.s24,
                  children: [
                    Expanded(
                      flex: PatientLayoutConstants.appointmentsPrimaryFlex,
                      child: _PatientAppointmentsPrimaryColumn(
                        overview: overview,
                      ),
                    ),
                    Expanded(
                      flex: PatientLayoutConstants.appointmentsSecondaryFlex,
                      child: _PatientAppointmentsSecondaryColumn(
                        overview: overview,
                      ),
                    ),
                  ],
                )
              else ...[
                _PatientAppointmentsPrimaryColumn(overview: overview),
                _PatientAppointmentsSecondaryColumn(overview: overview),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
