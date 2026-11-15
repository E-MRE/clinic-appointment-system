/// Counts the elements of an iterable by a key derived from each element.
extension IterableCountBy<T> on Iterable<T> {
  /// Returns an unmodifiable map containing each [keyOf] result and its count.
  Map<K, int> countBy<K>(K Function(T element) keyOf) {
    final counts = <K, int>{};
    for (final element in this) {
      final key = keyOf(element);
      counts.update(key, (int count) => count + 1, ifAbsent: () => 1);
    }
    return Map<K, int>.unmodifiable(counts);
  }
}
