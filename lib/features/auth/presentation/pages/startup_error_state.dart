part of 'startup_error_page.dart';

/// Wrapped error state presentation for startup error page.
final class _StartupErrorState extends StatelessWidget {
  const _StartupErrorState({
    required this.kind,
    required this.isMobile,
    required this.actions,
  });

  final StartupErrorKind kind;
  final bool isMobile;
  final Widget actions;

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return ErrorState(
      title: kind.config.titleKey.translate(),
      primaryAction: isMobile ? null : actions,
      message: kind.config.descriptionKey.translate(),
      icon: _buildIcon(context),
      iconBackground: kind.containerColor(colors),
      iconSize: context.screenSize.select(
        mobile: AppSizes.s96,
        tablet: AppSizes.illustrationLarge,
        desktop: AppSizes.illustrationLarge,
      ),
    );
  }

  /// Builds the illustration for the current startup error kind.
  Widget _buildIcon(BuildContext context) {
    return SquareSvgIcon(
      asset: kind.illustration,
      size: isMobile ? AppSizes.s32 : AppSizes.s48,
      color: kind.onContainerColor(context.colorScheme),
    );
  }
}
