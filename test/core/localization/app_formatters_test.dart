import 'package:clinic_appointment_system/core/localization/localization.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await AppFormatters.ensureInitialized();
  });

  group('AppFormatters - Turkish locale', () {
    final dateTime = DateTime(2026, 10, 12, 14, 30);

    test('formats appointment date as 12.10.2026', () {
      expect(AppFormatters.formatDate(dateTime, locale: 'tr'), '12.10.2026');
      expect(AppFormatters.formatDate(dateTime, locale: 'tr_TR'), '12.10.2026');
    });

    test('formats appointment time as 14:30', () {
      expect(AppFormatters.formatTime(dateTime, locale: 'tr'), '14:30');
      expect(AppFormatters.formatTime(dateTime, locale: 'tr_TR'), '14:30');
    });

    test('formats appointment datetime as 12.10.2026 14:30', () {
      expect(
        AppFormatters.formatDateTime(dateTime, locale: 'tr'),
        '12.10.2026 14:30',
      );
      expect(
        AppFormatters.formatDateTime(dateTime, locale: 'tr_TR'),
        '12.10.2026 14:30',
      );
    });

    test('formats service fee as ₺1.250,00', () {
      expect(AppFormatters.formatCurrency(1250, locale: 'tr'), '₺1.250,00');
      expect(AppFormatters.formatCurrency(1250, locale: 'tr_TR'), '₺1.250,00');
      expect(
        AppFormatters.formatCurrency(1250.50, locale: 'tr_TR'),
        '₺1.250,50',
      );
      expect(AppFormatters.formatCurrency(0, locale: 'tr_TR'), '₺0,00');
    });

    test('formats currency with custom symbol and decimal digits', () {
      expect(
        AppFormatters.formatCurrency(1250, locale: 'tr', symbol: 'TL '),
        'TL 1.250,00',
      );
      expect(
        AppFormatters.formatCurrency(1250, locale: 'tr', decimalDigits: 0),
        '₺1.250',
      );
    });
  });

  group('AppFormatters - English locale', () {
    final dateTime = DateTime(2026, 10, 12, 14, 30);

    test('formats appointment date as 10/12/2026', () {
      expect(AppFormatters.formatDate(dateTime, locale: 'en'), '10/12/2026');
      expect(AppFormatters.formatDate(dateTime, locale: 'en_US'), '10/12/2026');
    });

    test('formats appointment time as 2:30 PM', () {
      expect(AppFormatters.formatTime(dateTime, locale: 'en'), '2:30 PM');
      expect(AppFormatters.formatTime(dateTime, locale: 'en_US'), '2:30 PM');
    });

    test('formats appointment datetime as 10/12/2026 2:30 PM', () {
      expect(
        AppFormatters.formatDateTime(dateTime, locale: 'en'),
        '10/12/2026 2:30 PM',
      );
      expect(
        AppFormatters.formatDateTime(dateTime, locale: 'en_US'),
        '10/12/2026 2:30 PM',
      );
    });

    test('formats service fee as \$1,250.00', () {
      expect(AppFormatters.formatCurrency(1250, locale: 'en'), r'$1,250.00');
      expect(AppFormatters.formatCurrency(1250, locale: 'en_US'), r'$1,250.00');
      expect(
        AppFormatters.formatCurrency(1250.50, locale: 'en_US'),
        r'$1,250.50',
      );
      expect(AppFormatters.formatCurrency(0, locale: 'en_US'), r'$0.00');
    });
  });

  group('AppFormatters - Default fallback', () {
    final dateTime = DateTime(2026, 10, 12, 14, 30);

    test('defaults to Turkish formatting when locale is omitted', () {
      expect(AppFormatters.formatDate(dateTime), '12.10.2026');
      expect(AppFormatters.formatTime(dateTime), '14:30');
      expect(AppFormatters.formatDateTime(dateTime), '12.10.2026 14:30');
      expect(AppFormatters.formatCurrency(1250), '₺1.250,00');
    });
  });
}
