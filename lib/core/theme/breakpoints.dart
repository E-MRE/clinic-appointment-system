/// Layout size class of the viewport.
enum ScreenSize { mobile, tablet, desktop }

/// Responsive breakpoints (logical pixels). Pure Dart, no Flutter import.
abstract final class Breakpoints {
  static const double tablet = 600;
  static const double desktop = 840;

  /// Maps a viewport [width] to a [ScreenSize].
  static ScreenSize resolve(double width) {
    if (width < tablet) {
      return ScreenSize.mobile;
    }
    if (width < desktop) {
      return ScreenSize.tablet;
    }
    return ScreenSize.desktop;
  }
}
