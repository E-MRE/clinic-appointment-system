part of 'startup_error_page.dart';

/// Startup illustration colored by its error variant.
final class _StartupErrorIcon extends StatelessWidget {
  const _StartupErrorIcon({required this.kind, required this.isMobile});

  final StartupErrorKind kind;
  final bool isMobile;

  @override
  Widget build(BuildContext context) {
    return SquareSvgIcon(
      asset: kind.illustration,
      size: isMobile ? AppSizes.s32 : AppSizes.s48,
      color: kind.onContainerColor(context.colorScheme),
    );
  }
}
