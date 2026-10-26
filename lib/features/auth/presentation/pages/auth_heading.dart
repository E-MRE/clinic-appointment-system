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
          Assets.images.auth.signInLogo.svg(
            width: size.select(
              mobile: AppSizes.s56,
              tablet: AppSizes.s64,
              desktop: AppSizes.s56,
            ),
            excludeFromSemantics: true,
          ),
          const EmptySize.s24Height(),
        ],
        if (!size.isMobile || !kind.offersBack)
          Semantics(
            header: true,
            child: AppText.headline(kind.titleKey.translate()),
          ),
        const EmptySize.s8Height(),
        AppText.body(
          kind.descriptionKeyFor(size).translate(),
          textAlign: centered ? TextAlign.center : TextAlign.start,
          tone: TextTone.muted,
        ),
      ],
    );
  }
}
