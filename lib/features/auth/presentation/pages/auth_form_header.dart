part of 'auth_page.dart';

/// Uses the compact mobile header and centered tablet sign-in heading.
final class _AuthFormHeader extends StatelessWidget {
  const _AuthFormHeader({required this.kind});
  final AuthFormKind kind;

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    final centered = size.isTablet && kind.isSignIn;
    if (size.isTablet && kind.isRegistration) {
      return Row(
        spacing: AppSizes.s16,
        children: [
          Assets.images.auth.signInLogo.svg(
            width: AppSizes.s48,
            excludeFromSemantics: true,
          ),
          Expanded(child: _buildHeading(context, centered)),
        ],
      );
    }
    return _buildHeading(context, centered);
  }

  /// Builds the responsive sign-in logo, spacing, title, and description.
  Widget _buildHeading(BuildContext context, bool centered) {
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
