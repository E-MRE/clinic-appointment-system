part of 'patient_book_page.dart';

/// The date and time step: week navigation, days and slots.
final class _PatientBookScheduleCard extends StatelessWidget {
  const _PatientBookScheduleCard({required this.catalog});

  final ClinicCatalog catalog;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      radius: AppSurfaceRadius.panel,
      padding: AppSurfacePadding.comfortable,
      child: BlocBuilder<BookingSelectionCubit, BookingSelection>(
        builder: (context, selection) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSizes.s20,
            children: [
              _PatientBookScheduleHeader(
                selection: selection,
                catalog: catalog,
              ),
              _PatientBookScheduleBody(selection: selection),
            ],
          );
        },
      ),
    );
  }
}
