part of 'auth_page.dart';

/// App logo shown above heading in non-desktop sign-in flows.
final class _AuthHeadingLogo extends StatelessWidget {
  const _AuthHeadingLogo();

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    return Assets.images.auth.signInLogo.svg(
      width: size.select(
        mobile: AppSizes.s56,
        tablet: AppSizes.s64,
        desktop: AppSizes.s56,
      ),
      excludeFromSemantics: true,
    );
  }
}
