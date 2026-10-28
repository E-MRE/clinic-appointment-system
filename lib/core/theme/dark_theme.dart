import 'package:clinic_appointment_system/core/theme/app_brand_colors.dart';
import 'package:clinic_appointment_system/core/theme/app_theme.dart';
import 'package:clinic_appointment_system/core/theme/appointment_status_colors.dart';
import 'package:clinic_appointment_system/core/theme/breakpoints.dart';
import 'package:clinic_appointment_system/generated/colors.gen.dart';
import 'package:flutter/material.dart';

/// Dark application theme. One instance per [ScreenSize] is reused, so
/// rebuilding `MaterialApp` does not rebuild the [ThemeData].
final class DarkTheme extends AppTheme {
  factory DarkTheme(ScreenSize screenSize) {
    return _instances[screenSize] ??= DarkTheme._(screenSize);
  }

  DarkTheme._(super.screenSize);

  static final Map<ScreenSize, DarkTheme> _instances =
      <ScreenSize, DarkTheme>{};

  @override
  ColorScheme get colorScheme {
    return ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      brightness: Brightness.dark,
    ).copyWith(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.darkOnPrimary,
      primaryContainer: AppColors.darkPrimaryContainer,
      onPrimaryContainer: AppColors.darkOnPrimaryContainer,
      secondary: AppColors.darkSecondary,
      secondaryContainer: AppColors.darkSecondaryContainer,
      onSecondaryContainer: AppColors.darkOnSecondaryContainer,
      tertiary: AppColors.darkTertiary,
      tertiaryContainer: AppColors.darkTertiaryContainer,
      onTertiaryContainer: AppColors.darkOnTertiaryContainer,
      surface: AppColors.darkSurface,
      surfaceContainer: AppColors.darkSurfaceContainer,
      surfaceContainerHigh: AppColors.darkSurfaceContainerHigh,
      surfaceContainerLow: AppColors.darkSurfaceContainerLow,
      inverseSurface: AppColors.darkInverseSurface,
      onInverseSurface: AppColors.darkOnInverseSurface,
      onSurface: AppColors.darkOnSurface,
      onSurfaceVariant: AppColors.darkOnSurfaceVariant,
      outline: AppColors.darkOutline,
      outlineVariant: AppColors.darkOutlineVariant,
      error: AppColors.darkError,
      onError: AppColors.darkOnError,
      errorContainer: AppColors.darkErrorContainer,
      onErrorContainer: AppColors.darkOnErrorContainer,
    );
  }

  @override
  AppBrandColors get brandColors {
    return const AppBrandColors.dark();
  }

  @override
  AppointmentStatusColors get statusColors {
    return AppointmentStatusColors.dark;
  }
}
