import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/generated/colors.gen.dart';
import 'package:clinic_appointment_system/generated/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TextRole', () {
    for (final screenSize in ScreenSize.values) {
      test('resolves every role for $screenSize', () {
        final textTheme = LightTheme(screenSize).themeData.textTheme;
        for (final role in TextRole.values) {
          final style = role.resolve(textTheme);
          expect(style, isNotNull);
          final expected = _expectedTextStyle(role, screenSize);

          expect(style?.fontSize, expected.fontSize, reason: '$role size');
          expect(
            style?.fontWeight,
            expected.fontWeight,
            reason: '$role weight',
          );
          expect(
            style?.fontFamily,
            expected.fontFamily,
            reason: '$role family',
          );
          expect(style?.height, expected.height, reason: '$role line height');
        }
      });
    }
  });

  group('TextTone', () {
    test('resolves every tone in light and dark themes', () {
      for (final brightness in Brightness.values) {
        final theme = brightness == Brightness.light
            ? LightTheme(ScreenSize.mobile).themeData
            : DarkTheme(ScreenSize.mobile).themeData;
        final extension = theme.extension<AppBrandColors>();
        expect(extension, isNotNull);
        final brandColors = extension ?? const AppBrandColors.light();
        for (final tone in TextTone.values) {
          expect(
            tone.resolve(
              theme.colorScheme,
              brandForeground: brandColors.splashForeground,
            ),
            _expectedToneColor(tone, brightness),
            reason: '$tone in $brightness theme',
          );
        }
      }
    });
  });

  testWidgets('AppText applies role, tone and Text configuration', (
    tester,
  ) async {
    const widget = AppText.caption(
      'Supporting text',
      tone: TextTone.muted,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.center,
      softWrap: false,
      semanticsLabel: 'Accessible label',
    );

    expect(widget.role, TextRole.caption);
    expect(widget.tone, TextTone.muted);
    final theme = LightTheme(ScreenSize.mobile).themeData;
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Scaffold(body: widget),
      ),
    );

    final text = tester.widget<Text>(find.text('Supporting text'));
    expect(text.maxLines, 2);
    expect(text.overflow, TextOverflow.ellipsis);
    expect(text.textAlign, TextAlign.center);
    expect(text.softWrap, isFalse);
    expect(text.semanticsLabel, 'Accessible label');
    expect(text.style?.fontSize, theme.textTheme.bodySmall?.fontSize);
    expect(text.style?.fontFamily, FontFamily.notoSans);
    expect(text.style?.color, theme.colorScheme.onSurfaceVariant);
  });
}

TextStyle _expectedTextStyle(TextRole role, ScreenSize screenSize) {
  final fontFamily = switch (role) {
    TextRole.display ||
    TextRole.headline ||
    TextRole.pageTitle ||
    TextRole.sectionTitle ||
    TextRole.cardTitle => FontFamily.figtree,
    _ => FontFamily.notoSans,
  };
  final fontWeight = switch (role) {
    TextRole.display => FontWeight.w700,
    TextRole.headline ||
    TextRole.pageTitle ||
    TextRole.sectionTitle ||
    TextRole.cardTitle ||
    TextRole.bodyStrong ||
    TextRole.badge => FontWeight.w600,
    TextRole.label => FontWeight.w500,
    _ => FontWeight.w400,
  };
  final fontSize = switch (role) {
    TextRole.display => screenSize.select(
      mobile: 28.0,
      tablet: 32.0,
      desktop: 40.0,
    ),
    TextRole.headline => screenSize.select(
      mobile: 24.0,
      tablet: 28.0,
      desktop: 32.0,
    ),
    TextRole.pageTitle => screenSize.select(
      mobile: 22.0,
      tablet: 26.0,
      desktop: 30.0,
    ),
    TextRole.sectionTitle => screenSize.select(
      mobile: 18.0,
      tablet: 20.0,
      desktop: 20.0,
    ),
    TextRole.cardTitle || TextRole.bodyLarge => 16.0,
    TextRole.body || TextRole.bodyStrong || TextRole.label => 14.0,
    TextRole.caption || TextRole.badge => 12.0,
  };
  final height = switch (role) {
    TextRole.display => 1.2,
    TextRole.headline || TextRole.pageTitle => 1.25,
    TextRole.sectionTitle => 1.3,
    TextRole.cardTitle => 1.375,
    TextRole.bodyLarge => 1.5,
    TextRole.body || TextRole.bodyStrong || TextRole.label => 1.43,
    TextRole.caption || TextRole.badge => 1.33,
  };
  return TextStyle(
    fontFamily: fontFamily,
    fontWeight: fontWeight,
    fontSize: fontSize,
    height: height,
  );
}

Color _expectedToneColor(TextTone tone, Brightness brightness) {
  if (brightness == Brightness.light) {
    return switch (tone) {
      TextTone.normal => AppColors.lightOnSurface,
      TextTone.muted => AppColors.lightOnSurfaceVariant,
      TextTone.primary => AppColors.lightPrimary,
      TextTone.onPrimary => AppColors.lightOnPrimary,
      TextTone.onPrimaryContainer => AppColors.lightOnPrimaryContainer,
      TextTone.onSecondaryContainer => AppColors.lightOnSecondaryContainer,
      TextTone.onTertiaryContainer => AppColors.lightOnTertiaryContainer,
      TextTone.error => AppColors.lightError,
      TextTone.onError => AppColors.lightOnError,
      TextTone.onErrorContainer => AppColors.lightOnErrorContainer,
      TextTone.onInverse => AppColors.lightOnInverseSurface,
      TextTone.onBrand => AppColors.lightOnPrimary,
    };
  }
  return switch (tone) {
    TextTone.normal => AppColors.darkOnSurface,
    TextTone.muted => AppColors.darkOnSurfaceVariant,
    TextTone.primary => AppColors.darkPrimary,
    TextTone.onPrimary => AppColors.darkOnPrimary,
    TextTone.onPrimaryContainer => AppColors.darkOnPrimaryContainer,
    TextTone.onSecondaryContainer => AppColors.darkOnSecondaryContainer,
    TextTone.onTertiaryContainer => AppColors.darkOnTertiaryContainer,
    TextTone.error => AppColors.darkError,
    TextTone.onError => AppColors.darkOnError,
    TextTone.onErrorContainer => AppColors.darkOnErrorContainer,
    TextTone.onInverse => AppColors.darkOnInverseSurface,
    TextTone.onBrand => AppColors.darkOnSplash,
  };
}
