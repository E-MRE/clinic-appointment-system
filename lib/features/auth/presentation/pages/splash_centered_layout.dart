part of 'splash_page.dart';

/// Splash with the brand centered and the progress pinned near the bottom.
final class _SplashCenteredLayout extends StatelessWidget {
  const _SplashCenteredLayout();

  @override
  Widget build(BuildContext context) => Stack(
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
          mobile: AppSizes.section,
          tablet: AppSizes.sectionLarge,
          desktop: AppSizes.section,
        ),
        child: const _SplashProgress(),
      ),
    ],
  );
}
