part of 'component_preview_page.dart';

/// Viewport widths available in the catalogue.
enum _PreviewWidth implements _PreviewLabel {
  /// Uses the available window width.
  automatic(label: LocaleKeys.componentPreview_automatic, width: null),

  /// Representative mobile viewport.
  mobile(
    label: LocaleKeys.componentPreview_mobile,
    width: AppSizes.previewMobileWidth,
  ),

  /// Representative tablet viewport.
  tablet(
    label: LocaleKeys.componentPreview_tablet,
    width: AppSizes.previewTabletWidth,
  ),

  /// Representative desktop viewport.
  desktop(
    label: LocaleKeys.componentPreview_desktop,
    width: AppSizes.previewDesktopWidth,
  );

  const _PreviewWidth({required this.label, required this.width});

  /// Localization key for the displayed choice.
  @override
  final String label;

  /// Fixed viewport width, or null when using the available width.
  final double? width;
}
