import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> loadTestTranslations(
  WidgetTester tester, {
  Widget child = const SizedBox(),
  ThemeData? theme,
  bool disableAnimations = false,
  bool settle = true,
  TextScaler? textScaler,
}) async {
  await pumpLocalizedWidget(
    tester,
    LocalizationWrapper(
      child: Builder(
        builder: (context) => MaterialApp(
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          theme: theme,
          builder: (context, content) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              disableAnimations: disableAnimations,
              textScaler: textScaler,
            ),
            child: content ?? const SizedBox.shrink(),
          ),
          home: child,
        ),
      ),
    ),
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
}

/// Waits for actual JSON asset IO outside the widget test's fake-async zone.
Future<void> pumpLocalizedWidget(WidgetTester tester, Widget widget) async {
  await tester.runAsync(() async {
    const loader = RootBundleAssetLoader();
    for (final locale in LocalizationConfig.supportedLocales) {
      await loader.load(LocalizationConfig.path, locale);
    }
    await tester.pumpWidget(widget);
    await Future<void>.delayed(Duration.zero);
  });
  await tester.pump();
}
