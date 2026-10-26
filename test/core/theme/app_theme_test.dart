import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/generated/colors.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('light theme matches the design system', () {
    expect(
      LightTheme(ScreenSize.mobile).themeData.brightness,
      Brightness.light,
    );
    expect(LightTheme(ScreenSize.mobile).themeData.useMaterial3, isTrue);
    expect(
      LightTheme(ScreenSize.mobile).themeData.colorScheme.primary,
      AppColors.lightPrimary,
    );
    expect(
      LightTheme(ScreenSize.mobile).themeData.colorScheme.surface,
      AppColors.lightSurface,
    );
    expect(
      LightTheme(
        ScreenSize.mobile,
      ).themeData.extension<AppointmentStatusColors>(),
      AppointmentStatusColors.light,
    );
  });

  test('dark theme matches the design system', () {
    expect(DarkTheme(ScreenSize.mobile).themeData.brightness, Brightness.dark);
    expect(DarkTheme(ScreenSize.mobile).themeData.useMaterial3, isTrue);
    expect(
      DarkTheme(ScreenSize.mobile).themeData.colorScheme.primary,
      AppColors.darkPrimary,
    );
    expect(
      DarkTheme(ScreenSize.mobile).themeData.colorScheme.surface,
      AppColors.darkSurface,
    );
    expect(
      DarkTheme(
        ScreenSize.mobile,
      ).themeData.extension<AppointmentStatusColors>(),
      AppointmentStatusColors.dark,
    );
  });

  test('primary values equal the chosen palette', () {
    expect(
      LightTheme(ScreenSize.mobile).themeData.colorScheme.primary,
      const Color(0xFF0E7490),
    );
    expect(
      DarkTheme(ScreenSize.mobile).themeData.colorScheme.primary,
      const Color(0xFF6FD3EA),
    );
  });

  test('reuses one theme per screen size and brightness', () {
    expect(
      LightTheme(ScreenSize.tablet).themeData,
      same(LightTheme(ScreenSize.tablet).themeData),
    );
    expect(
      DarkTheme(ScreenSize.tablet).themeData,
      same(DarkTheme(ScreenSize.tablet).themeData),
    );
  });

  test('resolves typography for the screen size', () {
    double? headlineSize(ScreenSize size) =>
        LightTheme(size).themeData.textTheme.headlineSmall?.fontSize;

    expect(headlineSize(ScreenSize.mobile), 20);
    expect(headlineSize(ScreenSize.tablet), 24);
    expect(headlineSize(ScreenSize.desktop), 28);
  });
}
