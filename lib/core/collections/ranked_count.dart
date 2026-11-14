import 'package:equatable/equatable.dart';

/// A counted key with its display label and fraction of the largest count.
final class RankedCount<K> extends Equatable {
  /// Creates one ranked count result.
  const RankedCount({
    required this.key,
    required this.label,
    required this.count,
    required this.fractionOfMaximum,
  });

  /// The key whose occurrences were counted.
  final K key;

  /// The display label resolved for [key].
  final String label;

  /// The number of occurrences of [key].
  final int count;

  /// [count] divided by the largest count in the ranked collection.
  final double fractionOfMaximum;

  @override
  List<Object?> get props => [key, label, count, fractionOfMaximum];
}
