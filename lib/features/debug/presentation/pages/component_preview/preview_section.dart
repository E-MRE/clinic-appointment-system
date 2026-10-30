part of 'component_preview_page.dart';

/// Sections in the component catalogue.
enum _PreviewSection {
  /// Text samples.
  text(label: LocaleKeys.componentPreview_text),

  /// Surface samples.
  surface(label: LocaleKeys.componentPreview_surface),

  /// Status samples.
  status(label: LocaleKeys.componentPreview_status),

  /// Header samples.
  header(label: LocaleKeys.componentPreview_header),

  /// States samples.
  states(label: LocaleKeys.componentPreview_states),

  /// Loading samples.
  loading(label: LocaleKeys.componentPreview_loading),

  /// List samples.
  list(label: LocaleKeys.componentPreview_list),

  /// Data table samples.
  dataTable(label: LocaleKeys.componentPreview_dataTable),

  /// Avatar samples.
  avatar(label: LocaleKeys.componentPreview_avatar),

  /// Fields samples.
  fields(label: LocaleKeys.componentPreview_fields),

  /// Choices samples.
  choices(label: LocaleKeys.componentPreview_choices),

  /// Navigation samples.
  navigation(label: LocaleKeys.componentPreview_navigation),

  /// Other samples.
  other(label: LocaleKeys.componentPreview_extras);

  const _PreviewSection({required this.label});

  /// Localization key for the section heading.
  final String label;
}
