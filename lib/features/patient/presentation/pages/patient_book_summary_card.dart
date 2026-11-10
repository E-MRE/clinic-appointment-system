part of 'patient_book_page.dart';

/// The summary step: chosen values, the approval note and the request.
final class _PatientBookSummaryCard extends StatelessWidget {
  const _PatientBookSummaryCard({required this.catalog, required this.patient});

  final PatientCatalog catalog;
  final PatientAppointmentActor patient;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      radius: AppSurfaceRadius.panel,
      padding: AppSurfacePadding.comfortable,
      child: BlocBuilder<BookingSelectionCubit, BookingSelection>(
        builder: (context, selection) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSizes.s16,
            children: [
              _PatientBookSectionTitle(
                title: LocaleKeys.patient_book_summaryTitle.translate(),
              ),
              _PatientBookSummaryValues(selection: selection, catalog: catalog),
              AppMessageBanner(
                message: LocaleKeys.patient_book_info.translate(),
                variant: AppMessageBannerVariant.highlight,
              ),
              _PatientBookSubmitArea(selection: selection, patient: patient),
            ],
          );
        },
      ),
    );
  }
}
