/// Layout size class of the viewport.
enum ScreenSize {
  mobile,
  tablet,
  desktop;

  bool get isMobile => this == ScreenSize.mobile;

  bool get isTablet => this == ScreenSize.tablet;

  bool get isDesktop => this == ScreenSize.desktop;

  /// Picks the value that belongs to this screen size.
  T select<T>({required T mobile, required T tablet, required T desktop}) {
    return switch (this) {
      ScreenSize.mobile => mobile,
      ScreenSize.tablet => tablet,
      ScreenSize.desktop => desktop,
    };
  }
}
