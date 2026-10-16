import 'dart:ui';

/// Raw color values of the design system (palette "Clinical Teal").
///
/// This is the only file allowed to contain `Color(0x...)` literals.
abstract final class AppColors {
  /// Seed used for `ColorScheme.fromSeed`.
  static const Color brand = Color(0xFF0E7490);

  // ============ Light roles ============
  static const Color lightPrimary = Color(0xFF0E7490);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightPrimaryContainer = Color(0xFFCFF3FA);
  static const Color lightOnPrimaryContainer = Color(0xFF06303B);
  static const Color lightSecondary = Color(0xFF4A6572);
  static const Color lightTertiary = Color(0xFFB4572E);
  static const Color lightSurface = Color(0xFFF7FBFC);
  static const Color lightSurfaceContainerLow = Color(0xFFEEF5F7);
  static const Color lightOnSurface = Color(0xFF15262C);
  static const Color lightOnSurfaceVariant = Color(0xFF46595F);
  static const Color lightOutline = Color(0xFF6F8389);
  static const Color lightOutlineVariant = Color(0xFFC4D4D8);
  static const Color lightError = Color(0xFFBA1A1A);

  // ============ Dark roles ============
  static const Color darkPrimary = Color(0xFF6FD3EA);
  static const Color darkOnPrimary = Color(0xFF00363F);
  static const Color darkPrimaryContainer = Color(0xFF0B5565);
  static const Color darkOnPrimaryContainer = Color(0xFFCFF3FA);
  static const Color darkSecondary = Color(0xFFB2CAD4);
  static const Color darkTertiary = Color(0xFFF2B79A);
  static const Color darkSurface = Color(0xFF0F1A1E);
  static const Color darkSurfaceContainerLow = Color(0xFF162328);
  static const Color darkOnSurface = Color(0xFFDDE7EA);
  static const Color darkOnSurfaceVariant = Color(0xFFB0C0C5);
  static const Color darkOutline = Color(0xFF7A8E94);
  static const Color darkOutlineVariant = Color(0xFF33454B);
  static const Color darkError = Color(0xFFFFB4AB);

  // ============ Appointment status (light) ============
  static const Color pendingLightBg = Color(0xFFFEF3C7);
  static const Color pendingLightFg = Color(0xFF7A4A00);
  static const Color approvedLightBg = Color(0xFFDCFCE7);
  static const Color approvedLightFg = Color(0xFF14602F);
  static const Color rejectedLightBg = Color(0xFFFEE2E2);
  static const Color rejectedLightFg = Color(0xFF9B1C1C);
  static const Color completedLightBg = Color(0xFFDBEAFE);
  static const Color completedLightFg = Color(0xFF1E429F);
  static const Color noShowLightBg = Color(0xFFF3E3F8);
  static const Color noShowLightFg = Color(0xFF7B1E8F);
  static const Color cancelledLightBg = Color(0xFFE5E7EB);
  static const Color cancelledLightFg = Color(0xFF374151);

  // ============ Appointment status (dark) ============
  static const Color pendingDarkBg = Color(0xFF4A3600);
  static const Color pendingDarkFg = Color(0xFFFDD87A);
  static const Color approvedDarkBg = Color(0xFF12391F);
  static const Color approvedDarkFg = Color(0xFF8FE0A8);
  static const Color rejectedDarkBg = Color(0xFF4C1717);
  static const Color rejectedDarkFg = Color(0xFFFFB3AD);
  static const Color completedDarkBg = Color(0xFF172B54);
  static const Color completedDarkFg = Color(0xFFA9C4FA);
  static const Color noShowDarkBg = Color(0xFF3F1A4A);
  static const Color noShowDarkFg = Color(0xFFE3B5F0);
  static const Color cancelledDarkBg = Color(0xFF2B2F36);
  static const Color cancelledDarkFg = Color(0xFFC5CAD3);
}
