import 'package:clinic_appointment_system/core/theme/app_padding.dart';
import 'package:clinic_appointment_system/core/theme/app_radius.dart';
import 'package:clinic_appointment_system/core/theme/app_sizes.dart';
import 'package:clinic_appointment_system/core/theme/app_typography.dart';
import 'package:clinic_appointment_system/core/theme/appointment_status_colors.dart';
import 'package:clinic_appointment_system/core/theme/breakpoints.dart';
import 'package:flutter/material.dart';

/// Contract for the application themes.
///
/// Subclasses provide the brightness-specific colors; the shared component
/// setup (typography, buttons, inputs, cards, ...) lives here so light and
/// dark stay consistent. [themeData] is built once per instance.
abstract base class AppTheme {
  AppTheme(this.screenSize);

  /// Breakpoint the typography is resolved for.
  final ScreenSize screenSize;

  /// Brightness-specific Material color roles.
  ColorScheme get colorScheme;

  /// Brightness-specific appointment status colors.
  AppointmentStatusColors get statusColors;

  /// The [ThemeData] handed to `MaterialApp`.
  late final ThemeData themeData = _build();

  static const _buttonShape = RoundedRectangleBorder(
    borderRadius: AppRadius.medium(),
  );
  static const _buttonSize = Size(0, AppSizes.xxxl);

  ThemeData _build() {
    final scheme = colorScheme;
    final defaults = ThemeData(useMaterial3: true, colorScheme: scheme);
    final textTheme = AppTypography(defaults.textTheme, screenSize: screenSize);

    return defaults.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: scheme.surface,
      extensions: <ThemeExtension<dynamic>>[statusColors],
      appBarTheme: _appBarTheme(scheme, textTheme),
      filledButtonTheme: _filledButtonTheme(textTheme),
      outlinedButtonTheme: _outlinedButtonTheme(scheme, textTheme),
      textButtonTheme: _textButtonTheme(textTheme),
      cardTheme: _cardTheme(scheme),
      inputDecorationTheme: _inputDecorationTheme(scheme),
      chipTheme: _chipTheme(textTheme),
      dividerTheme: _dividerTheme(scheme),
      dialogTheme: _dialogTheme(scheme),
    );
  }

  AppBarTheme _appBarTheme(ColorScheme scheme, TextTheme textTheme) =>
      AppBarTheme(
        backgroundColor: scheme.surface,
        foregroundColor: scheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: textTheme.titleLarge?.copyWith(color: scheme.onSurface),
      );

  FilledButtonThemeData _filledButtonTheme(TextTheme textTheme) =>
      FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: _buttonSize,
          visualDensity: VisualDensity.standard,
          padding: const AppPadding.control(),
          shape: _buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      );

  OutlinedButtonThemeData _outlinedButtonTheme(
    ColorScheme scheme,
    TextTheme textTheme,
  ) => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      minimumSize: _buttonSize,
      visualDensity: VisualDensity.standard,
      padding: const AppPadding.control(),
      shape: _buttonShape,
      side: BorderSide(color: scheme.outline),
      textStyle: textTheme.labelLarge,
    ),
  );

  TextButtonThemeData _textButtonTheme(TextTheme textTheme) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: _buttonSize,
          visualDensity: VisualDensity.standard,
          shape: _buttonShape,
          textStyle: textTheme.labelLarge,
        ),
      );

  CardThemeData _cardTheme(ColorScheme scheme) => CardThemeData(
    elevation: 0,
    color: scheme.surfaceContainerLow,
    margin: const AppPadding.none(),
    shape: RoundedRectangleBorder(
      borderRadius: const AppRadius.medium(),
      side: BorderSide(
        color: scheme.outlineVariant,
        width: AppSizes.borderThin,
      ),
    ),
  );

  InputDecorationTheme _inputDecorationTheme(ColorScheme scheme) =>
      InputDecorationTheme(
        filled: true,
        fillColor: scheme.surfaceContainerLow,
        contentPadding: const AppPadding.control(),
        border: _inputBorder(scheme.outlineVariant),
        enabledBorder: _inputBorder(scheme.outlineVariant),
        focusedBorder: _inputBorder(scheme.primary, width: 2),
        errorBorder: _inputBorder(scheme.error),
        focusedErrorBorder: _inputBorder(scheme.error, width: 2),
      );

  OutlineInputBorder _inputBorder(Color color, {double width = 1}) =>
      OutlineInputBorder(
        borderRadius: const AppRadius.medium(),
        borderSide: BorderSide(color: color, width: width),
      );

  ChipThemeData _chipTheme(TextTheme textTheme) => ChipThemeData(
    shape: const StadiumBorder(),
    side: BorderSide.none,
    padding: const AppPadding.chip(),
    labelStyle: textTheme.labelMedium,
  );

  DividerThemeData _dividerTheme(ColorScheme scheme) => DividerThemeData(
    color: scheme.outlineVariant,
    thickness: AppSizes.borderThin,
    space: AppSizes.borderThin,
  );

  DialogThemeData _dialogTheme(ColorScheme scheme) => DialogThemeData(
    elevation: 0,
    backgroundColor: scheme.surface,
    shape: const RoundedRectangleBorder(borderRadius: AppRadius.large()),
  );
}
