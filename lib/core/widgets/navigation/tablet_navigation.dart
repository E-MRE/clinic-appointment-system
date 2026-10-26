part of 'app_navigation_shell.dart';

/// Tablet navigation rail with the application logo above its destinations.
final class _TabletNavigation extends StatelessWidget {
  const _TabletNavigation({
    required this.logo,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final SvgGenImage logo;
  final List<AppNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSizes.navigationRail,
      child: Material(
        color: context.colorScheme.surfaceContainer,
        child: Column(
          children: [
            const EmptySize.s16Height(),
            logo.svg(
              width: AppSizes.s40,
              height: AppSizes.s40,
              excludeFromSemantics: true,
            ),
            const EmptySize.s24Height(),
            Expanded(
              child: ListView(
                padding: const AppPadding.none(),
                children: [
                  for (var index = 0; index < destinations.length; index++)
                    _TabletNavigationItem(
                      destination: destinations[index],
                      selected: index == selectedIndex,
                      onTap: () {
                        onDestinationSelected(index);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
