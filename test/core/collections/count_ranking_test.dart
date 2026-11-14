import 'package:clinic_appointment_system/core/collections/count_ranking.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const ranking = CountRanking();

  test('orders by count, Turkish label, then key text', () {
    final counts = <String, int>{
      'top': 5,
      'i-key': 3,
      'dotless-i-key': 3,
      'cedilla-key': 3,
      'c-key': 3,
      'same-z': 3,
      'same-a': 3,
    };
    final labels = <String, String>{
      'top': 'En çok',
      'i-key': 'İpek',
      'dotless-i-key': 'Işıl',
      'cedilla-key': 'Çetin',
      'c-key': 'Can',
      'same-z': 'Aynı ad',
      'same-a': 'Aynı ad',
    };

    final ranked = ranking.rank(counts, (String key) {
      final label = labels[key];
      if (label == null) return key;
      return label;
    });

    expect(ranked.map((entry) => entry.key), [
      'top',
      'same-a',
      'same-z',
      'c-key',
      'cedilla-key',
      'dotless-i-key',
      'i-key',
    ]);
    expect(ranked.first.fractionOfMaximum, 1);
    expect(ranked.skip(1).map((entry) => entry.fractionOfMaximum), [
      3 / 5,
      3 / 5,
      3 / 5,
      3 / 5,
      3 / 5,
      3 / 5,
    ]);
  });

  test('returns zero fractions for counts whose maximum is zero', () {
    final ranked = ranking.rank({'zero': 0}, (String key) => key);

    expect(ranked.single.fractionOfMaximum, 0);
  });

  test('returns an empty unmodifiable list for empty counts', () {
    final ranked = ranking.rank<String>({}, (String key) => key);

    expect(ranked, isEmpty);
    expect(() => ranked.clear(), throwsUnsupportedError);
  });
}
