part of 'splash_page.dart';

/// Splash with the brand centered and the progress pinned near the bottom.
final class _SplashCenteredLayout extends StatelessWidget {
  const _SplashCenteredLayout();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: Padding(
            padding: AppPadding.horizontalXl(),
            child: _SplashBrand(),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: context.screenSize.select(
            mobile: AppSizes.s96,
            tablet: AppSizes.s144,
            desktop: AppSizes.s96,
          ),
          child: const _SplashProgress(),
        ),
      ],
    );
  }
}
