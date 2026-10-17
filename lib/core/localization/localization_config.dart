import 'package:flutter/material.dart';

/// Configuration for application localization.
final class LocalizationConfig {
  const LocalizationConfig._();

  /// Path to the translation files directory.
  static const String path = 'assets/translations';

  /// Turkish locale.
  static const Locale tr = Locale('tr', 'TR');

  /// Fallback locale when device/browser locale is not supported.
  static const Locale fallbackLocale = tr;

  /// List of supported locales.
  static const List<Locale> supportedLocales = [tr];
}
