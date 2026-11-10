part of 'component_preview_page.dart';

/// Displays header section samples.
final class _HeaderSection extends StatelessWidget {
  const _HeaderSection();
  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (final width in _PreviewWidth.values) {
      final fixedWidth = width.width;
      if (fixedWidth is double) {
        children.add(
          _TierPreview(
            width: fixedWidth,
            child: PageHeader(
              title: width.label.translate(),
              subtitle: LocaleKeys.componentPreview_sample.translate(),
            ),
          ),
        );
      }
    }
    return Column(spacing: AppSizes.s8, children: children);
  }
}
