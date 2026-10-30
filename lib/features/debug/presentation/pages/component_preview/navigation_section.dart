part of 'component_preview_page.dart';

/// Displays navigation section samples.
final class _NavigationSection extends StatelessWidget {
  const _NavigationSection();
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSizes.s16,
      children: [
        for (final width in _PreviewWidth.values)
          if (width.width case final double fixedWidth)
            _TierPreview(
              width: fixedWidth,
              child: _NavigationPreviewShell(width: width),
            ),
      ],
    );
  }
}
