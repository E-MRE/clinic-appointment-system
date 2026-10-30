import 'package:clinic_appointment_system/core/theme/screen_size.dart';

/// Size checks and per-size value selection for [ScreenSize].
extension ScreenSizeSelection on ScreenSize {
  /// Whether this is the mobile size class.
  bool get isMobile => this == ScreenSize.mobile;

  /// Whether this is the tablet size class.
  bool get isTablet => this == ScreenSize.tablet;

  /// Whether this is the desktop size class.
  bool get isDesktop => this == ScreenSize.desktop;

  /// Returns the value given for this size class.
  T select<T>({required T mobile, required T tablet, required T desktop}) {
    return switch (this) {
      ScreenSize.mobile => mobile,
      ScreenSize.tablet => tablet,
      ScreenSize.desktop => desktop,
    };
  }
}
