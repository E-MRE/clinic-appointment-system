part of 'component_preview_page.dart';

/// Applies the selected theme to the component catalogue.
final class _PreviewThemedViewport extends StatelessWidget {
  const _PreviewThemedViewport({
    required this.size,
    required this.screenSize,
    required this.theme,
  });

  final Size size;
  final ScreenSize screenSize;
  final _PreviewTheme theme;

  @override
  Widget build(BuildContext context) {
    final themeData = theme.resolve(screenSize);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(size: size),
      child: Theme(
        data: themeData,
        child: Material(
          color: themeData.colorScheme.surface,
          child: ListView(
            children: [
              for (final section in _PreviewSection.values)
                _PreviewSectionView(
                  key: ValueKey(section.name),
                  section: section,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
