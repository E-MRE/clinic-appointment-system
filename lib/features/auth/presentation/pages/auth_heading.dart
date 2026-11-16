part of 'auth_page.dart';

/// Builds the responsive sign-in logo, spacing, title, and description.
final class _AuthHeading extends StatelessWidget {
  const _AuthHeading({required this.kind, required this.centered});

  final AuthFormKind kind;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (size.isMobile && kind.isSignIn) const EmptySize.s32Height(),
        if (!size.isDesktop && kind.isSignIn) ...[
          _buildSignInLogo(context),
          const EmptySize.s24Height(),
        ],
        _AuthHeadingTexts(kind: kind, centered: centered),
      ],
    );
  }

  /// Builds the sign-in logo at its existing responsive width.
  Widget _buildSignInLogo(BuildContext context) {
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
