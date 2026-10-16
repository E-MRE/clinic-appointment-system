import 'package:clinic_appointment_system/core/theme/app_colors.dart';
import 'package:clinic_appointment_system/core/theme/app_radius.dart';
import 'package:clinic_appointment_system/core/theme/app_sizes.dart';
import 'package:clinic_appointment_system/core/theme/app_spacing.dart';
import 'package:clinic_appointment_system/core/theme/app_typography.dart';
import 'package:clinic_appointment_system/core/theme/appointment_status_colors.dart';
import 'package:flutter/material.dart';

/// Single entry point for the application themes.
abstract final class AppTheme {
  static final ThemeData light = _build(
    ColorScheme.fromSeed(seedColor: AppColors.brand).copyWith(
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      primaryContainer: AppColors.lightPrimaryContainer,
      onPrimaryContainer: AppColors.lightOnPrimaryContainer,
      secondary: AppColors.lightSecondary,
      tertiary: AppColors.lightTertiary,
      surface: AppColors.lightSurface,
      surfaceContainerLow: AppColors.lightSurfaceContainerLow,
      onSurface: AppColors.lightOnSurface,
      onSurfaceVariant: AppColors.lightOnSurfaceVariant,
      outline: AppColors.lightOutline,
      outlineVariant: AppColors.lightOutlineVariant,
      error: AppColors.lightError,
    ),
    AppointmentStatusColors.light,
  );

  static final ThemeData dark = _build(
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
    ),
    AppointmentStatusColors.dark,
  );

  static ThemeData _build(
    ColorScheme scheme,
    AppointmentStatusColors statusColors,
  ) {
    final base = ThemeData(useMaterial3: true, colorScheme: scheme);
    final textTheme = AppTypography.textTheme(base.textTheme);
    const buttonShape = RoundedRectangleBorder(borderRadius: AppRadius.button);
    const buttonSize = Size(0, AppSizes.buttonHeightLg);

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      extensions: <ThemeExtension<dynamic>>[statusColors],
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: buttonSize,
          padding: AppPadding.control,
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: buttonSize,
          padding: AppPadding.control,
          shape: buttonShape,
          side: BorderSide(color: scheme.outline),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: buttonSize,
          shape: buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: scheme.surfaceContainerLow,
        margin: AppPadding.none,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(
            color: scheme.outlineVariant,
            width: AppSizes.borderThin,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        contentPadding: AppPadding.control,
        border: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: scheme.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: scheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.input,
          borderSide: BorderSide(color: scheme.error, width: 2),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        side: BorderSide.none,
        padding: AppPadding.chip,
        labelStyle: textTheme.labelMedium,
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant,
        thickness: AppSizes.borderThin,
        space: AppSizes.borderThin,
      ),
      dialogTheme: DialogThemeData(
        elevation: 0,
        backgroundColor: scheme.surface,
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.dialog),
      ),
    );
  }
}
