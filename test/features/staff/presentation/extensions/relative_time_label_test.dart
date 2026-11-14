import 'package:clinic_appointment_system/core/extensions/relative_time_label.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../support/localization_test_app.dart';

void main() {
  group('RelativeTimeLabel', () {
    final now = DateTime(2026, 10, 27, 15, 30);

    testWidgets('formats under 1 minute as "az önce"', (tester) async {
      await loadTestTranslations(tester);

      expect(now.relativeLabel(now), 'az önce');
      expect(
        now.subtract(const Duration(seconds: 30)).relativeLabel(now),
        'az önce',
      );
      expect(
        now.subtract(const Duration(seconds: 59)).relativeLabel(now),
        'az önce',
      );
    });

    testWidgets('formats under 1 hour as "{n} dk önce"', (tester) async {
      await loadTestTranslations(tester);

      expect(
        now.subtract(const Duration(minutes: 1)).relativeLabel(now),
        '1 dk önce',
      );
      expect(
        now.subtract(const Duration(minutes: 15)).relativeLabel(now),
        '15 dk önce',
      );
      expect(
        now.subtract(const Duration(minutes: 59)).relativeLabel(now),
        '59 dk önce',
      );
    });

    testWidgets('formats under 24 hours as "{n} saat önce"', (tester) async {
      await loadTestTranslations(tester);

      expect(
        now.subtract(const Duration(hours: 1)).relativeLabel(now),
        '1 saat önce',
      );
      expect(
        now.subtract(const Duration(hours: 2)).relativeLabel(now),
        '2 saat önce',
      );
      expect(
        now.subtract(const Duration(hours: 23)).relativeLabel(now),
        '23 saat önce',
      );
    });

    testWidgets('formats between 24 and 47 hours as "dün"', (tester) async {
      await loadTestTranslations(tester);

      expect(now.subtract(const Duration(hours: 24)).relativeLabel(now), 'dün');
      expect(now.subtract(const Duration(hours: 36)).relativeLabel(now), 'dün');
      expect(now.subtract(const Duration(hours: 47)).relativeLabel(now), 'dün');
    });

    testWidgets('formats 2 or more days as "{n} gün önce"', (tester) async {
      await loadTestTranslations(tester);

      expect(
        now.subtract(const Duration(days: 2)).relativeLabel(now),
        '2 gün önce',
      );
      expect(
        now.subtract(const Duration(days: 3)).relativeLabel(now),
        '3 gün önce',
      );
      expect(
        now.subtract(const Duration(days: 10)).relativeLabel(now),
        '10 gün önce',
      );
    });
  });
}
