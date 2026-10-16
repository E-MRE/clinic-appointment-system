import 'package:flutter/material.dart';

/// Typography: Figtree for display/headline/title, Noto Sans for body/label.
abstract final class AppTypography {
  static const String headingFamily = 'Figtree';
  static const String bodyFamily = 'Noto Sans';

  /// Applies the font families on top of the default Material 3 [base] theme.
  static TextTheme textTheme(TextTheme base) {
    TextStyle? heading(TextStyle? s, FontWeight w) =>
        s?.copyWith(fontFamily: headingFamily, fontWeight: w);
    TextStyle? body(TextStyle? s, FontWeight w) =>
        s?.copyWith(fontFamily: bodyFamily, fontWeight: w);

    return base.copyWith(
      displayLarge: heading(base.displayLarge, FontWeight.w700),
      displayMedium: heading(base.displayMedium, FontWeight.w700),
      displaySmall: heading(base.displaySmall, FontWeight.w600),
      headlineLarge: heading(base.headlineLarge, FontWeight.w600),
      headlineMedium: heading(base.headlineMedium, FontWeight.w600),
      headlineSmall: heading(base.headlineSmall, FontWeight.w600),
      titleLarge: heading(base.titleLarge, FontWeight.w600),
      titleMedium: heading(base.titleMedium, FontWeight.w600),
      titleSmall: heading(base.titleSmall, FontWeight.w600),
      bodyLarge: body(base.bodyLarge, FontWeight.w400),
      bodyMedium: body(base.bodyMedium, FontWeight.w400),
      bodySmall: body(base.bodySmall, FontWeight.w400),
      labelLarge: body(base.labelLarge, FontWeight.w500),
      labelMedium: body(base.labelMedium, FontWeight.w500),
      labelSmall: body(base.labelSmall, FontWeight.w500),
    );
  }
}
