part of 'patient_book_page.dart';

/// A numbered booking step heading.
final class _PatientBookSectionTitle extends StatelessWidget {
  const _PatientBookSectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Semantics(header: true, child: AppText.cardTitle(title));
  }
}
