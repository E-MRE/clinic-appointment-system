part of 'component_preview_page.dart';

/// Service title and caption column with medical icon for service table preview.
final class _PreviewServiceCell extends StatelessWidget {
  const _PreviewServiceCell({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: AppSizes.s8,
      children: [
        const Icon(Icons.medical_services_outlined),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.bodyStrong(name),
            const AppText.caption('Genel hizmet', tone: TextTone.muted),
          ],
        ),
      ],
    );
  }
}
