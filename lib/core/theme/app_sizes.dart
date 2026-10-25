/// Single size scale for spacing, icons, controls and layout constraints.
/// Use these instead of numeric literals.
///
/// Scale (4px grid):
/// * xs → 4
/// * sm → 8
/// * md → 12
/// * lg → 16
/// * xl → 24
/// * xxl → 32
/// * xxxl → 48
/// * section → 96
/// * sectionLarge → 144
///
/// Widget-specific sizes that do not fit the scale:
/// * borderThin → 1
/// * retryIcon → 20
/// * errorGlyphMobile → 40
/// * logoTablet → 112
/// * logoDesktop → 120
/// * illustrationLarge → 120
/// * progressWidthSm → 160
/// * progressWidthMd → 200
/// * progressWidthLg → 240
/// * messageMaxWidth → 520
abstract final class AppSizes {
  // Scale

  /// value = 4
  static const double xs = 4;

  /// value = 8
  static const double sm = 8;

  /// value = 12
  static const double md = 12;

  /// value = 16
  static const double lg = 16;

  /// value = 24
  static const double xl = 24;

  /// value = 32
  static const double xxl = 32;

  /// value = 48
  static const double xxxl = 48;

  /// value = 96
  static const double section = 96;

  /// value = 144
  static const double sectionLarge = 144;

  // Widget-specific

  /// Border and divider thickness.
  ///
  /// value = 1
  static const double borderThin = 1;

  /// Retry button icon.
  ///
  /// value = 20
  static const double retryIcon = 20;

  /// Startup error glyph on mobile.
  ///
  /// value = 40
  static const double errorGlyphMobile = 40;

  /// Splash logo on tablet.
  ///
  /// value = 112
  static const double logoTablet = 112;

  /// Splash logo on desktop.
  ///
  /// value = 120
  static const double logoDesktop = 120;

  /// Startup error illustration on tablet and desktop.
  ///
  /// value = 120
  static const double illustrationLarge = 120;

  /// Splash progress bar width on mobile.
  ///
  /// value = 160
  static const double progressWidthSm = 160;

  /// Splash progress bar width on tablet.
  ///
  /// value = 200
  static const double progressWidthMd = 200;

  /// Splash progress bar width on desktop.
  ///
  /// value = 240
  static const double progressWidthLg = 240;

  /// Max width of centered message blocks.
  ///
  /// value = 520
  static const double messageMaxWidth = 520;
}
