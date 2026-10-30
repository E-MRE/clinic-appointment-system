part of 'component_preview_page.dart';

/// The preview widget shown for a [_PreviewSection].
extension _PreviewSectionContent on _PreviewSection {
  Widget content() {
    return switch (this) {
      _PreviewSection.text => const _TextSection(),
      _PreviewSection.surface => const _SurfaceSection(),
      _PreviewSection.status => const _StatusSection(),
      _PreviewSection.header => const _HeaderSection(),
      _PreviewSection.states => const _StatesSection(),
      _PreviewSection.loading => const _LoadingSection(),
      _PreviewSection.list => const _ListSection(),
      _PreviewSection.dataTable => const _DataTableSection(),
      _PreviewSection.avatar => const _AvatarSection(),
      _PreviewSection.fields => const _FieldsSection(),
      _PreviewSection.choices => const _ChoicesSection(),
      _PreviewSection.navigation => const _NavigationSection(),
      _PreviewSection.other => const _OtherSection(),
    };
  }
}
