import 'package:clinic_appointment_system/core/extensions/currency_formatting.dart';
import 'package:clinic_appointment_system/core/extensions/date_time_formatting.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../support/date_formatting_test_support.dart';

void main() {
  setUpAll(initializeDateFormattingForTests);

  group('DateTimeFormatting - Turkish locale', () {
    final dateTime = DateTime(2026, 10, 12, 14, 30);

    test('formats appointment date as 12.10.2026', () {
      expect(dateTime.dateLabel(locale: 'tr'), '12.10.2026');
      expect(dateTime.dateLabel(locale: 'tr_TR'), '12.10.2026');
    });

    test('formats appointment time as 14:30', () {
      expect(dateTime.timeLabel(locale: 'tr'), '14:30');
      expect(dateTime.timeLabel(locale: 'tr_TR'), '14:30');
    });

    test('formats appointment datetime as 12.10.2026 14:30', () {
      expect(dateTime.dateTimeLabel(locale: 'tr'), '12.10.2026 14:30');
      expect(dateTime.dateTimeLabel(locale: 'tr_TR'), '12.10.2026 14:30');
    });

    test('formats a week range naming a shared month once', () {
      expect(
        DateTime(
          2026,
          10,
          26,
        ).dayRangeLabel(DateTime(2026, 10, 31), locale: 'tr_TR'),
        '26 – 31 Ekim',
      );
      expect(
        DateTime(
          2026,
          9,
          28,
        ).dayRangeLabel(DateTime(2026, 10, 3), locale: 'tr_TR'),
        '28 Eylül – 3 Ekim',
      );
    });

    test('formats long, month and abbreviated date labels', () {
      expect(dateTime.longDateLabel(locale: 'tr_TR'), '12 Ekim 2026');
      expect(dateTime.dayMonthLabel(locale: 'tr_TR'), '12 Ekim');
      expect(dateTime.dayShortMonthLabel(locale: 'tr_TR'), '12 Eki');
      expect(dateTime.shortMonthUpperLabel(locale: 'tr_TR'), 'EKİ');
    });

    test('formats a short date range with its ending year', () {
      expect(
        DateTime(
          2026,
          10,
          12,
        ).shortDateRangeLabel(DateTime(2026, 10, 14), locale: 'tr_TR'),
        '12 Eki – 14 Eki 2026',
      );
      expect(
        DateTime(
          2026,
          12,
          30,
        ).shortDateRangeLabel(DateTime(2027, 1, 3), locale: 'tr_TR'),
        '30 Ara 2026 – 3 Oca 2027',
      );
    });

    test('formats service fees and supports currency options', () {
      expect(1250.currencyLabel(locale: 'tr'), '₺1.250,00');
      expect(1250.currencyLabel(locale: 'tr_TR'), '₺1.250,00');
      expect(1250.50.currencyLabel(locale: 'tr_TR'), '₺1.250,50');
      expect(0.currencyLabel(locale: 'tr_TR'), '₺0,00');
      expect(1250.currencyLabel(locale: 'tr', symbol: 'TL '), 'TL 1.250,00');
      expect(1250.currencyLabel(locale: 'tr', decimalDigits: 0), '₺1.250');
    });
  });

  group('DateTimeFormatting - English locale', () {
    final dateTime = DateTime(2026, 10, 12, 14, 30);

    test('formats appointment date as 10/12/2026', () {
      expect(dateTime.dateLabel(locale: 'en'), '10/12/2026');
      expect(dateTime.dateLabel(locale: 'en_US'), '10/12/2026');
    });

    test('formats appointment time as 2:30 PM', () {
      expect(dateTime.timeLabel(locale: 'en'), '2:30 PM');
      expect(dateTime.timeLabel(locale: 'en_US'), '2:30 PM');
    });

    test('formats appointment datetime as 10/12/2026 2:30 PM', () {
      expect(dateTime.dateTimeLabel(locale: 'en'), '10/12/2026 2:30 PM');
      expect(dateTime.dateTimeLabel(locale: 'en_US'), '10/12/2026 2:30 PM');
    });

    test('formats service fees as \$1,250.00', () {
      expect(1250.currencyLabel(locale: 'en'), r'$1,250.00');
      expect(1250.currencyLabel(locale: 'en_US'), r'$1,250.00');
      expect(1250.50.currencyLabel(locale: 'en_US'), r'$1,250.50');
      expect(0.currencyLabel(locale: 'en_US'), r'$0.00');
    });
  });

  group('DateTimeFormatting - default locale fallback', () {
    final dateTime = DateTime(2026, 10, 12, 14, 30);

    test('defaults to Turkish formatting when locale is omitted', () {
      expect(dateTime.dateLabel(), '12.10.2026');
      expect(dateTime.timeLabel(), '14:30');
      expect(dateTime.dateTimeLabel(), '12.10.2026 14:30');
      expect(1250.currencyLabel(), '₺1.250,00');
    });
  });
}
