part of 'app_navigation_shell.dart';

/// App logo in the tablet navigation rail with top and bottom spacing.
final class _TabletNavigationLogo extends StatelessWidget {
  const _TabletNavigationLogo({required this.logo});

  final SvgGenImage logo;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const EmptySize.s16Height(),
        logo.svg(
          width: AppSizes.s40,
          height: AppSizes.s40,
          excludeFromSemantics: true,
        ),
        const EmptySize.s24Height(),
      ],
    );
  }
}
