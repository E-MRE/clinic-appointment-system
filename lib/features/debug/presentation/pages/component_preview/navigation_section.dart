part of 'component_preview_page.dart';

/// Displays navigation section samples.
final class _NavigationSection extends StatelessWidget {
  const _NavigationSection();
  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    for (final width in _PreviewWidth.values) {
      final fixedWidth = width.width;
      if (fixedWidth is double) {
        children.add(
          _TierPreview(
            width: fixedWidth,
            child: _NavigationPreviewShell(width: width),
          ),
        );
      }
    }
    return Column(spacing: AppSizes.s16, children: children);
  }
}
