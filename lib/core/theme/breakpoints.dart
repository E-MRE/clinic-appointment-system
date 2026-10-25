/// Layout size class of the viewport.
enum ScreenSize {
  mobile,
  tablet,
  desktop;

  bool get isMobile => this == ScreenSize.mobile;

  /// Picks the value that belongs to this screen size.
  T select<T>({required T mobile, required T tablet, required T desktop}) =>
      switch (this) {
        ScreenSize.mobile => mobile,
        ScreenSize.tablet => tablet,
        ScreenSize.desktop => desktop,
      };
}

/// Responsive breakpoints (logical pixels). Pure Dart, no Flutter import.
abstract final class Breakpoints {
  static const double tablet = 600;
  static const double desktop = 840;

  /// Viewport heights below this (e.g. phones in landscape) are compact:
  /// vertical space is scarce, so they always resolve to [ScreenSize.mobile].
  static const double shortHeight = 480;

  /// Viewport heights below this use the compact Splash layout.
  static const double compactHeight = 600;

  /// Text scale factors above this use the compact Splash layout.
  static const double largeTextScale = 1.3;

  /// Maps a viewport [width] and [height] to a [ScreenSize].
  static ScreenSize resolve(double width, double height) {
    if (width < tablet || height < shortHeight) {
      return ScreenSize.mobile;
    }
    if (width < desktop) {
      return ScreenSize.tablet;
    }
    return ScreenSize.desktop;
  }
}
