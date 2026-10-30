import 'package:clinic_appointment_system/core/localization/app_formatters.dart';
import 'package:clinic_appointment_system/features/medical_services/domain/value_objects/money.dart';
import 'package:clinic_appointment_system/features/medical_services/presentation/extensions/money_formatting.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() async {
    await AppFormatters.ensureInitialized();
  });

  group('MoneyFormatting', () {
    test('formats whole lira without decimals (₺1.200)', () {
      final money = Money.kurus(120000);
      expect(money.formatted(), '₺1.200');
    });

    test('formats fractional lira with two decimals (₺850,50)', () {
      final money = Money.kurus(85050);
      expect(money.formatted(), '₺850,50');
    });

    test('formats zero decimals for whole lira (₺850)', () {
      final money = Money.kurus(85000);
      expect(money.formatted(), '₺850');
    });

    test('inputText returns whole number for whole lira (850)', () {
      final money = Money.kurus(85000);
      expect(money.inputText, '850');
    });

    test('inputText returns comma decimal for fractional lira (850,50)', () {
      final money = Money.kurus(85050);
      expect(money.inputText, '850,50');
    });
  });
}
