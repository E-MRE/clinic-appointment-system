part of 'component_preview_page.dart';

/// Builds the theme a [_PreviewTheme] previews.
extension _PreviewThemeData on _PreviewTheme {
  ThemeData resolve(ScreenSize size) {
    return switch (mode) {
      ThemeMode.light || ThemeMode.system => LightTheme(size).themeData,
      ThemeMode.dark => DarkTheme(size).themeData,
    };
  }
}
