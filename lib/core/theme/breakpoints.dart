/// Layout size class of the viewport.
enum ScreenSize { mobile, tablet, desktop }

/// Convenience helpers and value selection for [ScreenSize].
extension ScreenSizeExtension on ScreenSize {
  bool get isMobile {
    return this == ScreenSize.mobile;
  }

  bool get isTablet {
    return this == ScreenSize.tablet;
  }

  bool get isDesktop {
    return this == ScreenSize.desktop;
  }

  /// Picks the value that belongs to this screen size.
  T select<T>({required T mobile, required T tablet, required T desktop}) {
    return switch (this) {
      ScreenSize.mobile => mobile,
      ScreenSize.tablet => tablet,
      ScreenSize.desktop => desktop,
    };
  }
}

/// Responsive breakpoint thresholds and layout constants (logical pixels).
final class BreakpointsConstants {
  const BreakpointsConstants._();

  /// Maximum mobile width breakpoint.
  /// value = 600
  static const double tablet = 600;

  /// Maximum tablet width breakpoint.
  /// value = 840
  static const double desktop = 840;

  /// Viewport heights below this (e.g. phones in landscape) are compact:
  /// vertical space is scarce, so they always resolve to [ScreenSize.mobile].
  /// value = 480
  static const double shortHeight = 480;

  /// Viewport heights below this use the compact Splash layout.
  /// value = 600
  static const double compactHeight = 600;

  /// Text scale factors above this use the compact Splash layout.
  /// value = 1.3
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
