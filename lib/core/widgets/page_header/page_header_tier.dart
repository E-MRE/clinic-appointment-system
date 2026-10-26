import 'package:clinic_appointment_system/core/theme/theme.dart';

/// Header sizing and subtitle typography for a screen tier.
enum PageHeaderTier {
  /// Mobile header uses a 64 px minimum and caption subtitle.
  mobile(AppSizes.pageHeaderMobileHeight, TextRole.caption),

  /// Tablet header uses an 88 px minimum and body-large subtitle.
  tablet(AppSizes.pageHeaderTabletHeight, TextRole.bodyLarge),

  /// Desktop header is content sized with body-large subtitle.
  desktop(AppSizes.pageHeaderDesktopMinimumHeight, TextRole.bodyLarge);

  const PageHeaderTier(this.minimumHeight, this.subtitleRole);

  /// Minimum header height for this tier.
  final double minimumHeight;

  /// Subtitle role for this tier.
  final TextRole subtitleRole;

  /// Resolves a screen size to its page-header tier.
  static PageHeaderTier from(ScreenSize size) {
    return size.select(mobile: mobile, tablet: tablet, desktop: desktop);
  }
}
