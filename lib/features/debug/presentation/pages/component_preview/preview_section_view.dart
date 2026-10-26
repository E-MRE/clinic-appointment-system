part of 'component_preview_page.dart';

/// Displays one labelled section in the catalogue.
final class _PreviewSectionView extends StatelessWidget {
  const _PreviewSectionView({required this.section, super.key});
  final _PreviewSection section;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const AppPadding.verticalXl(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s16,
        children: [
          Semantics(
            header: true,
            child: AppText.sectionTitle(section.label.translate()),
          ),
          section.content(),
        ],
      ),
    );
  }
}
