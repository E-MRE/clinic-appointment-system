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
            _TabletNavigationLogo(logo: logo),
            Expanded(
              child: _NavigationItemList(
                destinations: destinations,
                selectedIndex: selectedIndex,
                onDestinationSelected: onDestinationSelected,
                itemBuilder: _TabletNavigationItem.new,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
