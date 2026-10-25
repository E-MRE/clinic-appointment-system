import 'package:clinic_appointment_system/core/theme/app_theme.dart';
import 'package:clinic_appointment_system/core/theme/appointment_status_colors.dart';
import 'package:clinic_appointment_system/core/theme/breakpoints.dart';
import 'package:clinic_appointment_system/generated/colors.gen.dart';
import 'package:flutter/material.dart';

/// Dark application theme. One instance per [ScreenSize] is reused, so
/// rebuilding `MaterialApp` does not rebuild the [ThemeData].
final class DarkTheme extends AppTheme {
  factory DarkTheme(ScreenSize screenSize) =>
      _instances[screenSize] ??= DarkTheme._(screenSize);

  DarkTheme._(super.screenSize);

  static final _instances = <ScreenSize, DarkTheme>{};

  @override
  ColorScheme get colorScheme =>
      ColorScheme.fromSeed(
        seedColor: AppColors.brand,
        brightness: Brightness.dark,
      ).copyWith(
        primary: AppColors.darkPrimary,
        onPrimary: AppColors.darkOnPrimary,
        primaryContainer: AppColors.darkPrimaryContainer,
        onPrimaryContainer: AppColors.darkOnPrimaryContainer,
        secondary: AppColors.darkSecondary,
        tertiary: AppColors.darkTertiary,
        surface: AppColors.darkSurface,
        surfaceContainerLow: AppColors.darkSurfaceContainerLow,
        onSurface: AppColors.darkOnSurface,
        onSurfaceVariant: AppColors.darkOnSurfaceVariant,
        outline: AppColors.darkOutline,
        outlineVariant: AppColors.darkOutlineVariant,
        error: AppColors.darkError,
      );

  @override
  AppointmentStatusColors get statusColors => AppointmentStatusColors.dark;
}
