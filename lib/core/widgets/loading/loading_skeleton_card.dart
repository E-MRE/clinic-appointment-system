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
          Row(
            children: [
              _SkeletonBlock(
                width: variant.avatarSize,
                height: variant.avatarSize,
                radius: variant.avatarRadius,
              ),
              const EmptySize.s12Width(),
              const Expanded(
                child: Column(
                  children: [
                    _SkeletonLine(variant: LoadingSkeletonLineVariant.title),
                    EmptySize.s8Height(),
                    _SkeletonLine(variant: LoadingSkeletonLineVariant.metadata),
                  ],
                ),
              ),
            ],
          ),
          if (variant.hasDetails) ...[
            const EmptySize.s16Height(),
            const _SkeletonLine(variant: LoadingSkeletonLineVariant.fullWidth),
            const EmptySize.s8Height(),
            const _SkeletonLine(variant: LoadingSkeletonLineVariant.body),
            const EmptySize.s16Height(),
            const Row(
              children: [
                Expanded(child: _SkeletonBlock(height: AppSizes.s40)),
                EmptySize.s8Width(),
                Expanded(child: _SkeletonBlock(height: AppSizes.s40)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
