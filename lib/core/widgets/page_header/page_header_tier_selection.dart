import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/page_header/page_header_tier.dart';

/// Picks the [PageHeaderTier] for a [ScreenSize].
extension PageHeaderTierSelection on ScreenSize {
  /// The page header tier used at this size class.
  PageHeaderTier get pageHeaderTier {
    return select(
      mobile: PageHeaderTier.mobile,
      tablet: PageHeaderTier.tablet,
      desktop: PageHeaderTier.desktop,
    );
  }
}
