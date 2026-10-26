part of 'auth_page.dart';

/// Desktop brand surface, with its message separated from the page layout.
final class _AuthBrandPanel extends StatelessWidget {
  const _AuthBrandPanel({required this.kind});

  final AuthFormKind kind;

  @override
  Widget build(BuildContext context) {
    final brandColors = context.brandColors;
    return ColoredBox(
      color: brandColors.splashBackground,
      child: Padding(
        padding: const AppPadding.allXxxl(),
        child: ViewportScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: AppSizes.s32,
            children: [
              AppBrandHeader(
                logo: Assets.images.auth.panelLogo,
                logoSize: AppSizes.s32,
                textColor: brandColors.splashForeground,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: AnimatedSwitcher(
                  duration: kThemeAnimationDuration,
                  child: _AuthBrandMessage(
                    key: ValueKey(kind.brandTitleKey),
                    kind: kind,
                  ),
                ),
              ),
              Text(
                LocaleKeys.splash_subtitle.translate(),
                style: context.textTheme.bodySmall?.copyWith(
                  color: brandColors.splashForeground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
