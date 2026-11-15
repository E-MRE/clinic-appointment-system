import 'package:clinic_appointment_system/core/localization/locale_resolver.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Formats numeric amounts as locale-aware currency labels.
extension CurrencyFormatting on num {
  /// Formats this amount using the locale's currency conventions.
  String currencyLabel({
    String? locale,
    String? symbol,
    int decimalDigits = 2,
    BuildContext? context,
    LocaleResolver localeResolver = const LocaleResolver(),
  }) {
    final resolvedLocale = localeResolver.resolve(
      locale: locale,
      context: context,
    );
    final isTurkish = resolvedLocale.toLowerCase().startsWith('tr');
    final currencyLocale = isTurkish ? 'tr_TR' : resolvedLocale;
    final currencySymbol = symbol ?? (isTurkish ? '₺' : r'$');

    return NumberFormat.currency(
      locale: currencyLocale,
      symbol: currencySymbol,
      decimalDigits: decimalDigits,
    ).format(this);
  }
}
