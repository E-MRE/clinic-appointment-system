import 'package:clinic_appointment_system/core/theme/breakpoints.dart';
import 'package:clinic_appointment_system/generated/fonts.gen.dart';
import 'package:flutter/material.dart';

/// Typography: Figtree for display/headline/title, Noto Sans for body/label.
///
/// Shared text roles for every screen, built on top of [base] (which carries
/// the brightness-specific colors) and resolved at the app's breakpoint.
///
/// * displaySmall → 28 / 32 / 40, height 1.2
/// * headlineMedium → 24 / 28 / 32, height 1.25
/// * headlineSmall → 22 / 26 / 30, height 1.25
/// * titleLarge → 18 / 20 / 20, height 1.3
/// * titleMedium → 16 / 16 / 16, height 1.375
/// * bodyLarge → 16 / 16 / 16, height 1.5
/// * bodyMedium → 14 / 14 / 14, height 1.43
/// * bodySmall → 12 / 12 / 12, height 1.33
/// * labelLarge → 14 / 14 / 14, height 1.43
/// * labelMedium → 14 / 14 / 14, height 1.43
/// * labelSmall → 12 / 12 / 12, height 1.33
final class AppTypography extends TextTheme {
  AppTypography(TextTheme base, {ScreenSize screenSize = ScreenSize.mobile})
    : super(
        displaySmall: _heading(
          base.displaySmall,
          screenSize.select(mobile: 28, tablet: 32, desktop: 40),
          FontWeight.w700,
          1.2,
        ),
        headlineMedium: _heading(
          base.headlineMedium,
          screenSize.select(mobile: 24, tablet: 28, desktop: 32),
          FontWeight.w600,
          1.25,
        ),
        headlineSmall: _heading(
          base.headlineSmall,
          screenSize.select(mobile: 22, tablet: 26, desktop: 30),
          FontWeight.w600,
          1.25,
        ),
        titleLarge: _heading(
          base.titleLarge,
          screenSize.select(mobile: 18, tablet: 20, desktop: 20),
          FontWeight.w600,
          1.3,
        ),
        titleMedium: _heading(base.titleMedium, 16, FontWeight.w600, 1.375),
        bodyLarge: _body(base.bodyLarge, 16, 1.5),
        bodyMedium: _body(base.bodyMedium, 14, 1.43),
        bodySmall: _body(base.bodySmall, 12, 1.33),
        labelLarge: _label(base.labelLarge, 14, FontWeight.w600, 1.43),
        labelMedium: _label(base.labelMedium, 14, FontWeight.w500, 1.43),
        labelSmall: _label(base.labelSmall, 12, FontWeight.w600, 1.33),
      );

  static TextStyle? _style(
    TextStyle? base,
    String family,
    FontWeight weight,
    double size,
    double height,
  ) {
    return base?.copyWith(
      fontFamily: family,
      fontWeight: weight,
      fontSize: size,
      height: height,
      letterSpacing: 0,
    );
  }

  static TextStyle? _heading(
    TextStyle? base,
    double size,
    FontWeight weight,
    double height,
  ) {
    return _style(base, FontFamily.figtree, weight, size, height);
  }

  static TextStyle? _body(TextStyle? base, double size, double height) {
    return _style(base, FontFamily.notoSans, FontWeight.w400, size, height);
  }

  static TextStyle? _label(
    TextStyle? base,
    double size,
    FontWeight weight,
    double height,
  ) {
    return _style(base, FontFamily.notoSans, weight, size, height);
  }
}
