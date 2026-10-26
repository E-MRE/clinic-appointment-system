part of 'startup_error_page.dart';

/// Illustration on a tinted badge, smaller on mobile.
final class _StartupErrorBadge extends StatelessWidget {
  const _StartupErrorBadge({required this.kind});
  final StartupErrorKind kind;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    final isMobile = context.screenSize.isMobile;
    final badgeSize = isMobile ? AppSizes.s96 : AppSizes.illustrationLarge;
    final glyphSize = isMobile ? AppSizes.s32 : AppSizes.s48;
    return Container(
      width: badgeSize,
      height: badgeSize,
      decoration: BoxDecoration(
        color: kind.containerColor(colors),
        borderRadius: const AppRadius.xxLarge(),
      ),
      alignment: Alignment.center,
      child: SquareSvgIcon(
        asset: kind.illustration,
        size: glyphSize,
        color: kind.onContainerColor(colors),
      ),
    );
  }
}
