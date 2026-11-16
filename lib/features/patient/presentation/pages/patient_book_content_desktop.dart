part of 'patient_book_page.dart';

/// Places the three booking steps side by side on desktop.
final class _PatientBookContentDesktop extends StatelessWidget {
  const _PatientBookContentDesktop({
    required this.catalog,
    required this.patient,
    required this.patientName,
    required this.choiceColumn,
  });

  final ClinicCatalog catalog;
  final PatientAppointmentActor patient;
  final String patientName;
  final Widget choiceColumn;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.s20,
      children: [
        Expanded(
          flex: PatientLayoutConstants.bookingChoiceFlex,
          child: choiceColumn,
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
            patientName: patientName,
          ),
        ),
      ],
    );
  }
}
