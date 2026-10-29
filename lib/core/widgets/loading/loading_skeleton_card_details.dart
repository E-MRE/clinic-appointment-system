part of 'loading_state.dart';

/// Lower details rows of skeleton card with full width lines and action blocks.
final class _SkeletonCardDetails extends StatelessWidget {
  const _SkeletonCardDetails();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _SkeletonLine(variant: LoadingSkeletonLineVariant.fullWidth),
        EmptySize.s8Height(),
        _SkeletonLine(variant: LoadingSkeletonLineVariant.body),
        EmptySize.s16Height(),
        Row(
          children: [
            Expanded(child: _SkeletonBlock(height: AppSizes.s40)),
            EmptySize.s8Width(),
            Expanded(child: _SkeletonBlock(height: AppSizes.s40)),
          ],
        ),
      ],
    );
  }
}
