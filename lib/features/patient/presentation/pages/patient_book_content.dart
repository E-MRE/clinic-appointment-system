part of 'patient_book_page.dart';

/// Header and the three booking columns; one column below desktop width.
final class _PatientBookContent extends StatelessWidget {
  const _PatientBookContent({required this.catalog, required this.patient});

  final PatientCatalog catalog;
  final PatientAppointmentActor patient;

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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: AppSizes.s20,
                  children: [
                    Expanded(
                      flex: PatientLayoutConstants.bookingChoiceFlex,
                      child: _PatientBookChoiceColumn(catalog: catalog),
                    ),
                    Expanded(
                      flex: PatientLayoutConstants.bookingScheduleFlex,
                      child: _PatientBookScheduleCard(catalog: catalog),
                    ),
                    Expanded(
                      flex: PatientLayoutConstants.bookingSummaryFlex,
                      child: _PatientBookSummaryCard(
                        catalog: catalog,
                        patient: patient,
                      ),
                    ),
                  ],
                )
              else ...[
                _PatientBookChoiceColumn(catalog: catalog),
                _PatientBookScheduleCard(catalog: catalog),
                _PatientBookSummaryCard(catalog: catalog, patient: patient),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
