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
          Expanded(
            child: _AuthHeading(kind: kind, centered: centered),
          ),
        ],
      );
    }
    return _AuthHeading(kind: kind, centered: centered);
  }
}
