part of 'loading_state.dart';

/// Placeholder rows resembling the shared loading board.
final class _SkeletonList extends StatelessWidget {
  const _SkeletonList();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _SkeletonLine(variant: LoadingSkeletonLineVariant.headingWide),
        EmptySize.s16Height(),
        _SkeletonCard(variant: LoadingSkeletonCardVariant.featured),
        EmptySize.s16Height(),
        _SkeletonLine(variant: LoadingSkeletonLineVariant.headingShort),
        EmptySize.s8Height(),
        _SkeletonCard(variant: LoadingSkeletonCardVariant.compact),
      ],
    );
  }
}
