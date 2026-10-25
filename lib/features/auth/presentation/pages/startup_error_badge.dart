part of 'startup_error_page.dart';

/// Illustration on a tinted badge, smaller on mobile.
final class _StartupErrorBadge extends StatelessWidget {
  const _StartupErrorBadge({required this.kind});
  final StartupErrorKind kind;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final isMobile = context.screenSize.isMobile;
    final badgeSize = isMobile ? AppSizes.section : AppSizes.illustrationLarge;
    final glyphSize = isMobile ? AppSizes.errorGlyphMobile : AppSizes.xxxl;
    return Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
        color: kind.containerColor(colors),
        borderRadius: const AppRadius.xxLarge(),
      ),
      alignment: Alignment.center,
      child: kind.illustration.svg(
        width: glyphSize,
        height: glyphSize,
        colorFilter: ColorFilter.mode(
          kind.onContainerColor(colors),
          BlendMode.srcIn,
        ),
        excludeFromSemantics: true,
      ),
    );
  }
}
