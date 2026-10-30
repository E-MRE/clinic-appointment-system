part of 'medical_services_page.dart';

/// Header row for the dialog presenting section title and close button.
final class _MedicalServicesFormDialogHeader extends StatelessWidget {
  const _MedicalServicesFormDialogHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText.sectionTitle(title),
        IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}
