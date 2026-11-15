part of 'patient_book_page.dart';

/// A service with its kind, length, fee and department or preparation.
final class _PatientBookServiceCard extends StatelessWidget {
  const _PatientBookServiceCard({
    required this.service,
    required this.catalog,
    required this.isSelected,
  });

  final MedicalService service;
  final ClinicCatalog catalog;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return _PatientBookOptionCard(
      leading: AppIconTile(icon: service.kind.icon),
      title: service.name,
      captions: [service.bookingCaption, service.bookingDetail(catalog)],
      isSelected: isSelected,
      onTap: () {
        context.read<BookingSelectionCubit>().selectService(service);
      },
    );
  }
}
