import 'package:clinic_appointment_system/core/theme/breakpoints.dart';
import 'package:clinic_appointment_system/generated/fonts.gen.dart';
import 'package:flutter/material.dart';

/// Typography: Figtree for display/headline/title, Noto Sans for body/label.
///
/// Shared text roles for every screen, built on top of [base] (which carries
/// the brightness-specific colors) and resolved at the app's breakpoint.
final class AppTypography extends TextTheme {
  AppTypography(TextTheme base, {ScreenSize screenSize = ScreenSize.mobile})
    : super(
        displayLarge: _heading(
          base.displayLarge,
          screenSize.select(mobile: 48, tablet: 56, desktop: 64),
          bold: true,
        ),
        displayMedium: _heading(
          base.displayMedium,
          screenSize.select(mobile: 40, tablet: 48, desktop: 56),
          bold: true,
        ),
        displaySmall: _heading(
          base.displaySmall,
          screenSize.select(mobile: 36, tablet: 40, desktop: 48),
        ),
        headlineLarge: _heading(
          base.headlineLarge,
          screenSize.select(mobile: 28, tablet: 36, desktop: 40),
          bold: true,
        ),
        headlineMedium: _heading(
          base.headlineMedium,
          screenSize.select(mobile: 24, tablet: 28, desktop: 32),
        ),
        headlineSmall: _heading(
          base.headlineSmall,
          screenSize.select(mobile: 20, tablet: 24, desktop: 28),
        ),
        titleLarge: _heading(
          base.titleLarge,
          screenSize.select(mobile: 20, tablet: 22, desktop: 24),
        ),
        titleMedium: _heading(
          base.titleMedium,
          screenSize.select(mobile: 16, tablet: 18, desktop: 20),
        ),
        titleSmall: _heading(
          base.titleSmall,
          screenSize.select(mobile: 14, tablet: 16, desktop: 16),
        ),
        bodyLarge: _body(base.bodyLarge, 16),
        bodyMedium: _body(
          base.bodyMedium,
          screenSize.select(mobile: 14, tablet: 16, desktop: 16),
        ),
        bodySmall: _body(base.bodySmall, 12),
        labelLarge: _label(base.labelLarge, 14),
        labelMedium: _label(base.labelMedium, 12),
        labelSmall: _label(base.labelSmall, 11),
      );

  static TextStyle? _style(
    TextStyle? base,
    String family,
    FontWeight weight,
    double size,
    double height,
  ) => base?.copyWith(
    fontFamily: family,
    fontWeight: weight,
    fontSize: size,
    height: height,
    letterSpacing: 0,
  );

  static TextStyle? _heading(
    TextStyle? base,
    double size, {
    bool bold = false,
  }) => _style(
    base,
    FontFamily.figtree,
    bold ? FontWeight.w700 : FontWeight.w600,
    size,
    1.25,
  );

  static TextStyle? _body(TextStyle? base, double size) =>
      _style(base, FontFamily.notoSans, FontWeight.w400, size, 1.5);

  static TextStyle? _label(TextStyle? base, double size) =>
      _style(base, FontFamily.notoSans, FontWeight.w500, size, 1.4);
}
