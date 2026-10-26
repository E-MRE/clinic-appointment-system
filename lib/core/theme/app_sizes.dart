/// Single size scale for spacing, icons, controls and layout constraints.
/// Use these instead of numeric literals.
///
/// Scale (4px grid):
/// * s2 → 2
/// * s4 → 4
/// * s8 → 8
/// * s12 → 12
/// * s16 → 16
/// * s20 → 20
/// * s24 → 24
/// * s32 → 32
/// * s40 → 40
/// * s48 → 48
/// * s56 → 56
/// * s64 → 64
/// * s72 → 72
/// * s80 → 80
/// * s96 → 96
/// * s144 → 144
///
/// Widget-specific sizes that do not fit the scale:
/// * borderThin → 1
/// * borderThick → 2
/// * retryIcon → 20
/// * logoTablet → 112
/// * logoDesktop → 120
/// * illustrationLarge → 120
/// * progressWidthSm → 160
/// * progressWidthMd → 200
/// * progressWidthLg → 240
/// * messageMaxWidth → 520
/// * statusBadgeHeight → 24
/// * statusIcon → 12
/// * errorMessageTabletWidth → 480
/// * emptyMessageMobileWidth → 320
/// * emptyMessageTabletWidth → 400
/// * pageHeaderMobileHeight → 64
/// * pageHeaderTabletHeight → 88
/// * pageHeaderDesktopMinimumHeight → 0
/// * authFormWidth → 400
/// * registrationFormWidth → 440
/// * authCardWidth → 480
/// * authCardPadding → 40
abstract final class AppSizes {
  // Scale

  /// value = 2
  static const double s2 = 2;

  /// value = 4
  static const double s4 = 4;

  /// value = 8
  static const double s8 = 8;

  /// value = 12
  static const double s12 = 12;

  /// value = 16
  static const double s16 = 16;

  /// value = 20
  static const double s20 = 20;

  /// value = 24
  static const double s24 = 24;

  /// value = 32
  static const double s32 = 32;

  /// value = 40
  static const double s40 = 40;

  /// value = 48
  static const double s48 = 48;

  /// value = 56
  static const double s56 = 56;

  /// value = 64
  static const double s64 = 64;

  /// value = 72
  static const double s72 = 72;

  /// value = 80
  static const double s80 = 80;

  /// value = 96
  static const double s96 = 96;

  /// value = 144
  static const double s144 = 144;

  // Widget-specific

  /// Auth sign-in form maximum width.
  /// value = 400
  static const double authFormWidth = 400;

  /// Registration form maximum width.
  /// value = 440
  static const double registrationFormWidth = 440;

  /// Tablet sign-in card maximum width.
  /// value = 480
  static const double authCardWidth = 480;

  /// Tablet authentication card inset.
  /// value = 40
  static const double authCardPadding = s40;

  /// Border and divider thickness.
  ///
  /// value = 1
  static const double borderThin = 1;

  /// Selected and invalid border thickness.
  ///
  /// value = 2
  static const double borderThick = 2;

  /// Retry button icon.
  ///
  /// value = 20
  static const double retryIcon = s20;

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

  /// Status badge minimum height.
  /// value = 24
  static const double statusBadgeHeight = s24;

  /// Status badge icon size.
  /// value = 12
  static const double statusIcon = s12;

  /// Error-state message maximum width on tablet.
  /// value = 480
  static const double errorMessageTabletWidth = 480;

  /// Empty-state message maximum width on mobile.
  /// value = 320
  static const double emptyMessageMobileWidth = 320;

  /// Empty-state message maximum width on tablet and desktop.
  /// value = 400
  static const double emptyMessageTabletWidth = 400;

  /// Desktop page header minimum height.
  /// value = 0
  static const double pageHeaderDesktopMinimumHeight = 0;

  /// Page header height on mobile.
  /// value = 64
  static const double pageHeaderMobileHeight = s64;

  /// Tablet page header minimum height.
  /// value = 88
  static const double pageHeaderTabletHeight = 88;
}
