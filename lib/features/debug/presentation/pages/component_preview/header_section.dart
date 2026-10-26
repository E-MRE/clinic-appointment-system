part of 'component_preview_page.dart';

/// Displays header section samples.
final class _HeaderSection extends StatelessWidget {
  const _HeaderSection();
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSizes.s8,
      children: [
        for (final width in _PreviewWidth.values)
          if (width.width case final double fixedWidth)
            _TierPreview(
              width: fixedWidth,
              child: PageHeader(
                title: width.label.translate(),
                subtitle: LocaleKeys.componentPreview_sample.translate(),
              ),
            ),
      ],
    );
  }
}
