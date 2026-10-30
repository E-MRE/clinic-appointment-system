part of 'loading_state.dart';

/// One placeholder card with a leading block and text lines.
final class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({required this.variant});

  final LoadingSkeletonCardVariant variant;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SkeletonCardHeader(variant: variant),
          if (variant.hasDetails) ...[
            const EmptySize.s16Height(),
            const _SkeletonCardDetails(),
          ],
        ],
      ),
    );
  }
}
