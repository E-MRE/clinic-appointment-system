part of 'splash_page.dart';

/// App splash screen logo sized responsively.
final class _SplashBrandLogo extends StatelessWidget {
  const _SplashBrandLogo();

  @override
  Widget build(BuildContext context) {
    final logoSize = context.screenSize.select(
      mobile: AppSizes.s96,
      tablet: AppSizes.logoTablet,
      desktop: AppSizes.logoDesktop,
    );
    return Assets.images.brand.splashLogo.svg(
      width: logoSize,
      height: logoSize,
      excludeFromSemantics: true,
    );
  }
}
