import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> loadTestTranslations(WidgetTester tester) async {
  await tester.pumpWidget(
    LocalizationWrapper(
      child: Builder(
        builder: (context) => MaterialApp(
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          home: const SizedBox(),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
