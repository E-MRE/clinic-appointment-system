part of 'component_preview_page.dart';

/// Displays other section samples.
final class _OtherSection extends StatelessWidget {
  const _OtherSection();
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSizes.s16,
      children: [
        AppBrandHeader(
          logo: Assets.images.brand.clinicLogo,
          logoSize: AppSizes.s40,
        ),
        AnnouncedSemantics(
          label: LocaleKeys.componentPreview_sample.translate(),
          child: SquareSvgIcon(
            asset: Assets.images.status.retry,
            size: AppSizes.s24,
          ),
        ),
        const _OtherSectionViewportPreview(),
        const _SharedActionsPreview(),
      ],
    );
  }
}
