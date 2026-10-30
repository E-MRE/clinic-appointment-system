part of 'loading_state.dart';

/// Top row of skeleton card with avatar block and title/metadata lines.
final class _SkeletonCardHeader extends StatelessWidget {
  const _SkeletonCardHeader({required this.variant});

  final LoadingSkeletonCardVariant variant;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
