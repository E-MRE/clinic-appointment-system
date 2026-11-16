part of 'patient_book_page.dart';

/// Header and the three booking columns; one column below desktop width.
final class _PatientBookContent extends StatelessWidget {
  const _PatientBookContent({
    required this.catalog,
    required this.patient,
    required this.patientName,
  });

  final ClinicCatalog catalog;
  final PatientAppointmentActor patient;
  final String patientName;

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
                title: LocaleKeys.patient_book_title.translate(),
                subtitle: LocaleKeys.patient_book_subtitle.translate(),
              ),
              if (context.screenSize.isDesktop)
                _PatientBookContentDesktop(
                  catalog: catalog,
                  patient: patient,
                  patientName: patientName,
                  choiceColumn: _buildChoiceColumn(),
                )
              else ...[
                _buildChoiceColumn(),
                _PatientBookScheduleCard(catalog: catalog),
                _PatientBookSummaryCard(
                  catalog: catalog,
                  patient: patient,
                  patientName: patientName,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the service and staff selection steps.
  Column _buildChoiceColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s20,
      children: [
        _PatientBookServiceSection(catalog: catalog),
        _PatientBookStaffSection(catalog: catalog),
      ],
    );
  }
}
