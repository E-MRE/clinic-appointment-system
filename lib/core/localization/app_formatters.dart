import 'package:clinic_appointment_system/core/localization/localization_config.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/date_symbol_data_local.dart';

/// Locale-aware date, time, and currency formatting helpers for appointments and service fees.
final class AppFormatters {
  const AppFormatters._();

  /// Formats a date using the current locale's long date pattern.
  static String formatLongDate(
    DateTime dateTime, {
    String? locale,
    BuildContext? context,
  }) {
    return DateFormat.yMMMMd(
      _resolveLocale(locale: locale, context: context),
    ).format(dateTime);
  }

  /// Formats a day and month without a year in the active locale.
  static String formatDayMonth(DateTime dateTime, {String? locale}) {
    return DateFormat.MMMMd(_resolveLocale(locale: locale)).format(dateTime);
  }

  /// Formats an inclusive day range, naming the month once when both days
  /// share it.
  static String formatDayRange(DateTime start, DateTime end, {String? locale}) {
    final loc = _resolveLocale(locale: locale);
    final isSameMonth = start.year == end.year && start.month == end.month;
    final first = isSameMonth
        ? DateFormat.d(loc).format(start)
        : DateFormat.MMMMd(loc).format(start);
    return '$first – ${DateFormat.MMMMd(loc).format(end)}';
  }

  /// Formats a day and abbreviated month in the active locale.
  static String formatDayShortMonth(DateTime dateTime, {String? locale}) {
    return DateFormat.MMMd(_resolveLocale(locale: locale)).format(dateTime);
  }

  /// Formats an inclusive short day range and includes its ending year.
  static String formatShortDateRange(
    DateTime start,
    DateTime end, {
    String? locale,
    BuildContext? context,
  }) {
    final resolvedLocale = _resolveLocale(locale: locale, context: context);
    final startLabel = DateFormat.MMMd(resolvedLocale).format(start);
    final endLabel = DateFormat.MMMd(resolvedLocale).format(end);
    if (start.year == end.year) {
      return '$startLabel – $endLabel ${end.year}';
    }
    return '$startLabel ${start.year} – $endLabel ${end.year}';
  }

  /// Formats the abbreviated month in upper case, using Turkish casing rules
  /// for dotted and dotless letters in Turkish locales.
  static String formatShortMonthUpper(DateTime dateTime, {String? locale}) {
    final loc = _resolveLocale(locale: locale);
    final month = DateFormat.MMM(loc).format(dateTime);
    if (!loc.toLowerCase().startsWith('tr')) return month.toUpperCase();
    return month.replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();
  }

  /// Ensures date formatting symbols are initialized for the specified [locales].
  static Future<void> ensureInitialized([
    List<String> locales = const ['tr_TR', 'en_US', 'tr', 'en'],
  ]) async {
    for (final loc in locales) {
      await initializeDateFormatting(loc, null);
    }
  }

  /// Resolves the locale identifier to use.
  static String _resolveLocale({String? locale, BuildContext? context}) {
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

  /// Formats [dateTime] with locale-specific date and time patterns.
  static String formatDateTime(
    DateTime dateTime, {
    String? locale,
    BuildContext? context,
  }) {
    final loc = _resolveLocale(locale: locale, context: context);
    final isTurkish = loc.toLowerCase().startsWith('tr');
    final pattern = isTurkish
        ? DateFormat.yMd(loc).add_Hm()
        : DateFormat.yMd(loc).add_jm();
    return pattern.format(dateTime).replaceAll('\u202f', ' ');
  }

  /// Formats [dateTime] with the active locale's short date pattern.
  static String formatDate(
    DateTime dateTime, {
    String? locale,
    BuildContext? context,
  }) {
    final loc = _resolveLocale(locale: locale, context: context);
    return DateFormat.yMd(loc).format(dateTime);
  }

  /// Formats [dateTime] with a 24-hour Turkish clock or the active locale's
  /// time pattern.
  static String formatTime(
    DateTime dateTime, {
    String? locale,
    BuildContext? context,
  }) {
    final loc = _resolveLocale(locale: locale, context: context);
    final isTurkish = loc.toLowerCase().startsWith('tr');
    final pattern = isTurkish ? DateFormat.Hm(loc) : DateFormat.jm(loc);
    return pattern.format(dateTime).replaceAll('\u202f', ' ');
  }

  /// Formats [amount] with locale-specific currency conventions, defaulting
  /// to Turkish lira for Turkish locales and dollars otherwise.
  static String formatCurrency(
    num amount, {
    String? locale,
    String? symbol,
    int decimalDigits = 2,
    BuildContext? context,
  }) {
    final loc = _resolveLocale(locale: locale, context: context);
    final isTurkish = loc.toLowerCase().startsWith('tr');
    final resolvedLocale = isTurkish ? 'tr_TR' : loc;
    final resolvedSymbol = symbol ?? (isTurkish ? '₺' : r'$');

    return NumberFormat.currency(
      locale: resolvedLocale,
      symbol: resolvedSymbol,
      decimalDigits: decimalDigits,
    ).format(amount);
  }
}
