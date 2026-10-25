import 'package:clinic_appointment_system/core/localization/localization_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

/// Wraps the widget tree with [EasyLocalization] using [LocalizationConfig].
final class LocalizationWrapper extends StatelessWidget {
  const LocalizationWrapper({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return EasyLocalization(
      supportedLocales: LocalizationConfig.supportedLocales,
      fallbackLocale: LocalizationConfig.fallbackLocale,
      startLocale: LocalizationConfig.fallbackLocale,
      path: LocalizationConfig.path,
      child: child,
    );
  }
}
