part of 'loading_state.dart';

/// Skeleton line sized by a loading placeholder variant.
final class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.variant});

  final _SkeletonLineVariant variant;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: variant.widthFactor,
      child: _SkeletonBlock(
        height: variant.height,
        radius: const AppRadius.full(),
      ),
    );
  }
}
