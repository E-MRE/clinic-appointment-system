import 'package:flutter/painting.dart';

/// Spacing scale on a 4px grid. Use these instead of numeric literals.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

/// Ready-made [EdgeInsets] presets built from [AppSpacing].
abstract final class AppPadding {
  static const EdgeInsets none = EdgeInsets.zero;

  static const EdgeInsets allXs = EdgeInsets.all(AppSpacing.xs);
  static const EdgeInsets allSm = EdgeInsets.all(AppSpacing.sm);
  static const EdgeInsets allMd = EdgeInsets.all(AppSpacing.md);
  static const EdgeInsets allLg = EdgeInsets.all(AppSpacing.lg);
  static const EdgeInsets allXl = EdgeInsets.all(AppSpacing.xl);
  static const EdgeInsets allXxl = EdgeInsets.all(AppSpacing.xxl);

  static const EdgeInsets horizontalSm = EdgeInsets.symmetric(
    horizontal: AppSpacing.sm,
  );
  static const EdgeInsets horizontalLg = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
  );
  static const EdgeInsets horizontalXl = EdgeInsets.symmetric(
    horizontal: AppSpacing.xl,
  );
  static const EdgeInsets verticalSm = EdgeInsets.symmetric(
    vertical: AppSpacing.sm,
  );
  static const EdgeInsets verticalLg = EdgeInsets.symmetric(
    vertical: AppSpacing.lg,
  );

  /// Button and input content padding.
  static const EdgeInsets control = EdgeInsets.symmetric(
    horizontal: AppSpacing.lg,
    vertical: AppSpacing.md,
  );

  /// Chip and badge content padding.
  static const EdgeInsets chip = EdgeInsets.symmetric(
    horizontal: AppSpacing.md,
    vertical: AppSpacing.xs,
  );

  /// Card content padding.
  static const EdgeInsets card = EdgeInsets.all(AppSpacing.lg);

  static const EdgeInsets pageMobile = EdgeInsets.all(AppSpacing.lg);
  static const EdgeInsets pageTablet = EdgeInsets.all(AppSpacing.xl);
  static const EdgeInsets pageDesktop = EdgeInsets.all(AppSpacing.xxl);
}
