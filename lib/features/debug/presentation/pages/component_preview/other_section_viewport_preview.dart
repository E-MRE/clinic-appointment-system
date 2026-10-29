part of 'component_preview_page.dart';

/// Viewport scroll view preview within system overlay region.
final class _OtherSectionViewportPreview extends StatelessWidget {
  const _OtherSectionViewportPreview();

  @override
  Widget build(BuildContext context) {
    return SystemOverlayRegion(
      background: context.colorScheme.surface,
      child: SizedBox(
        height: AppSizes.s96,
        child: ViewportScrollView(
          child: Center(
            child: AppText.body(LocaleKeys.componentPreview_sample.translate()),
          ),
        ),
      ),
    );
  }
}
