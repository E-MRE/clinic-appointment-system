import 'package:clinic_appointment_system/generated/colors.gen.dart';
import 'package:flutter/material.dart';

/// Theme colors for splash and other full brand surfaces.
@immutable
final class AppBrandColors extends ThemeExtension<AppBrandColors> {
  /// Creates the colors for the light theme's brand surface.
  const AppBrandColors.light()
    : splashBackground = AppColors.brand,
      splashForeground = AppColors.lightOnPrimary;

  /// Creates the colors for the dark theme's brand surface.
  const AppBrandColors.dark()
    : splashBackground = AppColors.darkPrimaryContainer,
      splashForeground = AppColors.darkOnSplash;

  /// Background color of the splash and brand surfaces.
  final Color splashBackground;

  /// Foreground color of text on the splash and brand surfaces.
  final Color splashForeground;

  @override
  AppBrandColors copyWith({Color? splashBackground, Color? splashForeground}) {
    return AppBrandColors._(
      splashBackground ?? this.splashBackground,
      splashForeground ?? this.splashForeground,
    );
  }

  @override
  AppBrandColors lerp(covariant AppBrandColors? other, double t) {
    if (other == null) {
      return this;
    }
    return AppBrandColors._(
      Color.lerp(splashBackground, other.splashBackground, t) ??
          splashBackground,
      Color.lerp(splashForeground, other.splashForeground, t) ??
          splashForeground,
    );
  }

  const AppBrandColors._(this.splashBackground, this.splashForeground);
}
