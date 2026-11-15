import 'package:clinic_appointment_system/core/extensions/turkish_case_folding.dart';
import 'package:clinic_appointment_system/core/localization/locale_resolver.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Formats dates and times for localized labels.
extension DateTimeFormatting on DateTime {
  /// Formats this date with the locale's long date pattern.
  String longDateLabel({
    String? locale,
    BuildContext? context,
    LocaleResolver localeResolver = const LocaleResolver(),
  }) {
    return DateFormat.yMMMMd(
      localeResolver.resolve(locale: locale, context: context),
    ).format(this);
  }

  /// Formats this day and month without a year.
  String dayMonthLabel({
    String? locale,
    LocaleResolver localeResolver = const LocaleResolver(),
  }) {
    return DateFormat.MMMMd(
      localeResolver.resolve(locale: locale),
    ).format(this);
  }

  /// Formats this inclusive day range, naming a shared month once.
  String dayRangeLabel(
    DateTime end, {
    String? locale,
    LocaleResolver localeResolver = const LocaleResolver(),
  }) {
    final resolvedLocale = localeResolver.resolve(locale: locale);
    final isSameMonth = year == end.year && month == end.month;
    final first = isSameMonth
        ? DateFormat.d(resolvedLocale).format(this)
        : DateFormat.MMMMd(resolvedLocale).format(this);
    return '$first – ${DateFormat.MMMMd(resolvedLocale).format(end)}';
  }

  /// Formats this day and abbreviated month.
  String dayShortMonthLabel({
    String? locale,
    LocaleResolver localeResolver = const LocaleResolver(),
  }) {
    return DateFormat.MMMd(localeResolver.resolve(locale: locale)).format(this);
  }

  /// Formats this inclusive abbreviated date range and includes its years.
  String shortDateRangeLabel(
    DateTime end, {
    String? locale,
    BuildContext? context,
    LocaleResolver localeResolver = const LocaleResolver(),
  }) {
    final resolvedLocale = localeResolver.resolve(
      locale: locale,
      context: context,
    );
    final startLabel = DateFormat.MMMd(resolvedLocale).format(this);
    final endLabel = DateFormat.MMMd(resolvedLocale).format(end);
    if (year == end.year) {
      return '$startLabel – $endLabel ${end.year}';
    }
    return '$startLabel $year – $endLabel ${end.year}';
  }

  /// Formats the abbreviated month in upper case using Turkish casing rules.
  String shortMonthUpperLabel({
    String? locale,
    LocaleResolver localeResolver = const LocaleResolver(),
  }) {
    final resolvedLocale = localeResolver.resolve(locale: locale);
    final monthLabel = DateFormat.MMM(resolvedLocale).format(this);
    if (!resolvedLocale.toLowerCase().startsWith('tr')) {
      return monthLabel.toUpperCase();
    }
    return monthLabel.turkishUppercase;
  }

  /// Formats this date and time with a 24-hour Turkish clock when applicable.
  String dateTimeLabel({
    String? locale,
    BuildContext? context,
    LocaleResolver localeResolver = const LocaleResolver(),
  }) {
    final resolvedLocale = localeResolver.resolve(
      locale: locale,
      context: context,
    );
    final isTurkish = resolvedLocale.toLowerCase().startsWith('tr');
    final pattern = isTurkish
        ? DateFormat.yMd(resolvedLocale).add_Hm()
        : DateFormat.yMd(resolvedLocale).add_jm();
    return pattern.format(this).replaceAll('\u202f', ' ');
  }

  /// Formats this date with the locale's short date pattern.
  String dateLabel({
    String? locale,
    BuildContext? context,
    LocaleResolver localeResolver = const LocaleResolver(),
  }) {
    return DateFormat.yMd(
      localeResolver.resolve(locale: locale, context: context),
    ).format(this);
  }

  /// Formats this time with a 24-hour Turkish clock when applicable.
  String timeLabel({
    String? locale,
    BuildContext? context,
    LocaleResolver localeResolver = const LocaleResolver(),
  }) {
    final resolvedLocale = localeResolver.resolve(
      locale: locale,
      context: context,
    );
    final isTurkish = resolvedLocale.toLowerCase().startsWith('tr');
    final pattern = isTurkish
        ? DateFormat.Hm(resolvedLocale)
        : DateFormat.jm(resolvedLocale);
    return pattern.format(this).replaceAll('\u202f', ' ');
  }
}
