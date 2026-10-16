import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('light theme matches the design system', () {
    expect(AppTheme.light.brightness, Brightness.light);
    expect(AppTheme.light.useMaterial3, isTrue);
    expect(AppTheme.light.colorScheme.primary, AppColors.lightPrimary);
    expect(AppTheme.light.colorScheme.surface, AppColors.lightSurface);
    expect(
      AppTheme.light.extension<AppointmentStatusColors>(),
      AppointmentStatusColors.light,
    );
  });

  test('dark theme matches the design system', () {
    expect(AppTheme.dark.brightness, Brightness.dark);
    expect(AppTheme.dark.useMaterial3, isTrue);
    expect(AppTheme.dark.colorScheme.primary, AppColors.darkPrimary);
    expect(AppTheme.dark.colorScheme.surface, AppColors.darkSurface);
    expect(
      AppTheme.dark.extension<AppointmentStatusColors>(),
      AppointmentStatusColors.dark,
    );
  });

  test('primary values equal the chosen palette', () {
    expect(AppTheme.light.colorScheme.primary, const Color(0xFF0E7490));
    expect(AppTheme.dark.colorScheme.primary, const Color(0xFF6FD3EA));
  });
}
