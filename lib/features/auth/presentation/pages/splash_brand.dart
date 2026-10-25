part of 'splash_page.dart';

final class _SplashBrand extends StatelessWidget {
  const _SplashBrand();

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    final onPrimary = context.colorScheme.onPrimary;
    final logoSize = context.screenSize.select(
      mobile: AppSizes.section,
      tablet: AppSizes.logoTablet,
      desktop: AppSizes.logoDesktop,
    );
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSizes.messageMaxWidth),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.images.brand.splashLogo.svg(
            width: logoSize,
            height: logoSize,
            excludeFromSemantics: true,
          ),
          const EmptySize.xlHeight(),
          Text(
            LocaleKeys.appName.translate(),
            textAlign: TextAlign.center,
            style: textTheme.headlineLarge?.copyWith(color: onPrimary),
          ),
          const EmptySize.smHeight(),
          Text(
            LocaleKeys.splash_subtitle.translate(),
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(color: onPrimary),
          ),
        ],
      ),
    );
  }
}
