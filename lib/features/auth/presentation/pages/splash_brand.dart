part of 'splash_page.dart';

final class _SplashBrand extends StatelessWidget {
  const _SplashBrand();

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSizes.messageMaxWidth),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLogo(context),
          const EmptySize.s24Height(),
          const _SplashBrandTitles(),
        ],
      ),
    );
  }

  /// Builds the responsive, decorative splash logo.
  Widget _buildLogo(BuildContext context) {
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
