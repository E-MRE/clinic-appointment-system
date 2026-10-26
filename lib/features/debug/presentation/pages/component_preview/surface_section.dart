part of 'component_preview_page.dart';

/// Displays surface section samples.
final class _SurfaceSection extends StatelessWidget {
  const _SurfaceSection();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s8,
      children: [
        for (final variant in AppSurfaceVariant.values)
          for (final radius in AppSurfaceRadius.values)
            for (final padding in AppSurfacePadding.values)
              AppSurface(
                variant: variant,
                radius: radius,
                padding: padding,
                child: AppText.body(
                  '${variant.name} / ${radius.name} / ${padding.name}',
                ),
              ),
      ],
    );
  }
}
