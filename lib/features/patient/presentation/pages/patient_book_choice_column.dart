part of 'patient_book_page.dart';

/// The service step above the staff step.
final class _PatientBookChoiceColumn extends StatelessWidget {
  const _PatientBookChoiceColumn({required this.catalog});

  final PatientCatalog catalog;

  @override
  Widget build(BuildContext context) {
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
