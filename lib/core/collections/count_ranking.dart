import 'package:clinic_appointment_system/core/collections/ranked_count.dart';
import 'package:clinic_appointment_system/core/extensions/turkish_alphabetical_comparison.dart';

/// Orders counted keys by descending count, Turkish label, then key text.
final class CountRanking {
  /// Creates a stateless count ranking policy.
  const CountRanking();

  int get _equalOrder => 0;
  int get _zeroCount => 0;
  double get _zeroFraction => 0;

  /// Ranks [counts] and returns an unmodifiable list with normalized fractions.
  List<RankedCount<K>> rank<K>(
    Map<K, int> counts,
    String Function(K key) labelOf,
  ) {
    int? maximum;
    for (final count in counts.values) {
      if (maximum == null || count > maximum) {
        maximum = count;
      }
    }

    final rankedCounts = <RankedCount<K>>[];
    for (final entry in counts.entries) {
      final fraction = _fractionOfMaximum(entry.value, maximum);
      rankedCounts.add(
        RankedCount<K>(
          key: entry.key,
          label: labelOf(entry.key),
          count: entry.value,
          fractionOfMaximum: fraction,
        ),
      );
    }
    rankedCounts.sort(_compareRankedCounts);
    return List<RankedCount<K>>.unmodifiable(rankedCounts);
  }

  double _fractionOfMaximum(int count, int? maximum) {
    if (maximum == null || maximum == _zeroCount) return _zeroFraction;
    return count / maximum;
  }

  int _compareRankedCounts<K>(RankedCount<K> first, RankedCount<K> second) {
    final countOrder = second.count.compareTo(first.count);
    if (countOrder != _equalOrder) return countOrder;
    final labelOrder = first.label.compareTurkishAlphabetically(second.label);
    if (labelOrder != _equalOrder) return labelOrder;
    return first.key.toString().compareTo(second.key.toString());
  }
}
