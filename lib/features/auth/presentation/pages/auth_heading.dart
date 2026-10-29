part of 'auth_page.dart';

/// Responsive title, description and mobile/tablet sign-in logo.
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
          const _AuthHeadingLogo(),
          const EmptySize.s24Height(),
        ],
        _AuthHeadingTexts(kind: kind, centered: centered),
      ],
    );
  }
}
