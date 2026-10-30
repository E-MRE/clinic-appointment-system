part of 'component_preview_page.dart';

/// Local theme choices for the catalogue.
enum _PreviewTheme implements _PreviewLabel {
  /// Light theme.
  light(label: LocaleKeys.componentPreview_light, mode: ThemeMode.light),

  /// Dark theme.
  dark(label: LocaleKeys.componentPreview_dark, mode: ThemeMode.dark);

  const _PreviewTheme({required this.label, required this.mode});

  /// Localization key for the displayed choice.
  @override
  final String label;

  /// Theme mode used to resolve the preview theme.
  final ThemeMode mode;
}
