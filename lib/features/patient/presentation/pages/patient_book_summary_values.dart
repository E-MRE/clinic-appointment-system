part of 'patient_book_page.dart';

/// The chosen service, length, fee, staff member, place and time.
final class _PatientBookSummaryValues extends StatelessWidget {
  const _PatientBookSummaryValues({
    required this.selection,
    required this.catalog,
  });

  final BookingSelection selection;
  final ClinicCatalog catalog;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s12,
      children: [
        AppDefinitionRow(
          label: LocaleKeys.patient_book_summary_service.translate(),
          child: AppText.bodyStrong(selection.serviceValue),
        ),
        Row(
          spacing: AppSizes.s24,
          children: [
            AppDefinitionRow(
              label: LocaleKeys.patient_book_summary_duration.translate(),
              child: AppText.bodyStrong(selection.durationValue),
            ),
            AppDefinitionRow(
              label: LocaleKeys.patient_book_summary_fee.translate(),
              child: AppText.bodyStrong(selection.feeValue),
            ),
          ],
        ),
        AppDefinitionRow(
          label: LocaleKeys.patient_book_summary_staff.translate(),
          child: AppText.bodyStrong(selection.staffValue),
        ),
        AppDefinitionRow(
          label: LocaleKeys.patient_book_summary_location.translate(),
          child: AppText.bodyStrong(selection.locationValue(catalog)),
        ),
        AppDefinitionRow(
          label: LocaleKeys.patient_book_summary_dateTime.translate(),
          child: AppText.bodyStrong(selection.dateTimeValue),
        ),
      ],
    );
  }
}
