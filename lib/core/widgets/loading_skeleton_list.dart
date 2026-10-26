part of 'loading_state.dart';

/// Placeholder rows resembling the shared loading board.
final class _SkeletonList extends StatelessWidget {
  const _SkeletonList();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SkeletonLine(variant: _SkeletonLineVariant.headingWide),
        EmptySize.s16Height(),
        _SkeletonCard(variant: _SkeletonCardVariant.featured),
        EmptySize.s16Height(),
        _SkeletonLine(variant: _SkeletonLineVariant.headingShort),
        EmptySize.s8Height(),
        _SkeletonCard(variant: _SkeletonCardVariant.compact),
      ],
    );
  }
}
