import 'package:clinic_appointment_system/core/theme/app_brand_colors.dart';
import 'package:clinic_appointment_system/core/theme/appointment_status_colors.dart';
import 'package:flutter/material.dart';

/// Shared access to the inherited application theme.
extension BuildContextExtension on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;
  IconThemeData get iconTheme => IconTheme.of(this);
  Brightness get brightness => theme.brightness;
  bool get isDarkMode => brightness == Brightness.dark;
  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;

  T? themeExtension<T>() => theme.extension<T>();

  AppointmentStatusColors get statusColors =>
      themeExtension<AppointmentStatusColors>()!;

  AppBrandColors get brandColors => themeExtension<AppBrandColors>()!;

  /// How many times the user's text scaling enlarges [fontSize].
  ///
  /// Scaling can be nonlinear, so the factor depends on the size measured.
  double textScaleFor(double fontSize) =>
      MediaQuery.textScalerOf(this).scale(fontSize) / fontSize;
}
