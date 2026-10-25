import 'package:clinic_appointment_system/core/theme/app_theme.dart';
import 'package:clinic_appointment_system/core/theme/appointment_status_colors.dart';
import 'package:clinic_appointment_system/core/theme/breakpoints.dart';
import 'package:clinic_appointment_system/generated/colors.gen.dart';
import 'package:flutter/material.dart';

/// Light application theme. One instance per [ScreenSize] is reused, so
/// rebuilding `MaterialApp` does not rebuild the [ThemeData].
final class LightTheme extends AppTheme {
  factory LightTheme(ScreenSize screenSize) =>
      _instances[screenSize] ??= LightTheme._(screenSize);

  LightTheme._(super.screenSize);

  static final _instances = <ScreenSize, LightTheme>{};

  @override
  ColorScheme get colorScheme =>
      ColorScheme.fromSeed(seedColor: AppColors.brand).copyWith(
        primary: AppColors.lightPrimary,
        onPrimary: AppColors.lightOnPrimary,
        primaryContainer: AppColors.lightPrimaryContainer,
        onPrimaryContainer: AppColors.lightOnPrimaryContainer,
        secondary: AppColors.lightSecondary,
        secondaryContainer: AppColors.lightSecondaryContainer,
        tertiary: AppColors.lightTertiary,
        surface: AppColors.lightSurface,
        surfaceContainerLow: AppColors.lightSurfaceContainerLow,
        onSurface: AppColors.lightOnSurface,
        onSurfaceVariant: AppColors.lightOnSurfaceVariant,
        outline: AppColors.lightOutline,
        outlineVariant: AppColors.lightOutlineVariant,
        error: AppColors.lightError,
        errorContainer: AppColors.lightErrorContainer,
      );

  @override
  AppointmentStatusColors get statusColors => AppointmentStatusColors.light;
}
