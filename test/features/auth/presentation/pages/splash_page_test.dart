import 'package:clinic_appointment_system/core/constants/widget_key.dart';
import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/features/auth/presentation/pages/splash_page.dart';
import 'package:clinic_appointment_system/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  for (final (size, logoSize) in [
    (const Size(390, 844), AppSizes.s96),
    (const Size(834, 1194), AppSizes.logoTablet),
    (const Size(1440, 900), AppSizes.logoDesktop),
  ]) {
    testWidgets('Splash scales the shared SVG at $size', (tester) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await loadTestTranslations(
        tester,
        child: const SplashPage(),
        disableAnimations: true,
        theme: LightTheme(ScreenSize.mobile).themeData,
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const WidgetKey.splashPage()), findsOneWidget);
      expect(find.text('Klinik Randevu Sistemi'), findsOneWidget);
      expect(find.text('Hastane ve klinik randevuları'), findsOneWidget);
      expect(find.text('Yükleniyor...'), findsOneWidget);
      final image = tester.widget<SvgPicture>(find.byType(SvgPicture));
      expect(
        (image.bytesLoader as SvgAssetLoader).assetName,
        Assets.images.brand.splashLogo.path,
      );
      expect(image.width, logoSize);
      expect(image.height, logoSize);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets(
    'small viewport and large text remain scrollable without overflow',
    (tester) async {
      tester.view.physicalSize = const Size(320, 240);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await loadTestTranslations(
        tester,
        child: const SplashPage(),
        disableAnimations: true,
        textScaler: const TextScaler.linear(2),
        theme: LightTheme(ScreenSize.mobile).themeData,
      );
      await tester.pumpAndSettle();
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      await tester.ensureVisible(find.text('Yükleniyor...'));
      expect(tester.takeException(), isNull);
    },
  );

  for (final baseTheme in [
    LightTheme(ScreenSize.mobile).themeData,
    DarkTheme(ScreenSize.mobile).themeData,
  ]) {
    testWidgets('Splash uses ${baseTheme.brightness.name} brand colors', (
      tester,
    ) async {
      final brandColors = baseTheme.extension<AppBrandColors>();
      expect(brandColors, isNotNull);
      await loadTestTranslations(
        tester,
        child: const SplashPage(),
        disableAnimations: true,
        theme: baseTheme,
      );
      await tester.pumpAndSettle();
      final scaffold = tester.widget<Scaffold>(
        find.byKey(const WidgetKey.splashPage()),
      );
      expect(scaffold.backgroundColor, brandColors?.splashBackground);
      final title = tester.widget<Text>(find.text('Klinik Randevu Sistemi'));
      expect(title.style?.color, brandColors?.splashForeground);
      final progress = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(progress.color, brandColors?.splashForeground);
      expect(
        progress.backgroundColor,
        brandColors?.splashForeground.withValues(alpha: 0.25),
      );
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('loading animation is disposed when Splash leaves the tree', (
    tester,
  ) async {
    await loadTestTranslations(
      tester,
      child: const SplashPage(),
      theme: LightTheme(ScreenSize.mobile).themeData,
      settle: false,
    );
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpWidget(const SizedBox());
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}
