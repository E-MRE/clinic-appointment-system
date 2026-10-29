part of 'auth_page.dart';

/// Content column inside desktop auth brand panel.
final class _AuthBrandPanelContent extends StatelessWidget {
  const _AuthBrandPanelContent({required this.kind});

  final AuthFormKind kind;

  @override
  Widget build(BuildContext context) {
    final brandColors = context.brandColors;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s32,
      children: [
        AppBrandHeader(
          logo: Assets.images.auth.panelLogo,
          logoSize: AppSizes.s32,
          textColor: brandColors.splashForeground,
        ),
        _AuthBrandSwitcher(kind: kind),
        AppText.caption(
          LocaleKeys.splash_subtitle.translate(),
          tone: TextTone.onBrand,
        ),
      ],
    );
  }
}
