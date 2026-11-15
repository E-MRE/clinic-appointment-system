import 'package:clinic_appointment_system/core/localization/localization_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';

/// Resolves an explicit, inherited, or application fallback locale.
final class LocaleResolver {
  /// Creates a locale resolver.
  const LocaleResolver();

  /// Returns [locale], the context locale, the Intl default, or app fallback.
  String resolve({String? locale, BuildContext? context}) {
    if (locale != null && locale.isNotEmpty) return locale;
    if (context != null) {
      try {
        return context.locale.toString();
      } catch (_) {
        // Fall back if EasyLocalization is not in context.
      }
    }
    return Intl.defaultLocale ?? LocalizationConfig.fallbackLocale.toString();
  }
}
