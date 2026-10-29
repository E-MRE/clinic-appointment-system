part of 'app_navigation_shell.dart';

/// Scrollable list of destinations in the tablet navigation rail.
final class _TabletNavigationItemList extends StatelessWidget {
  const _TabletNavigationItemList({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<AppNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const AppPadding.none(),
      children: [
        for (int index = 0; index < destinations.length; index++)
          _TabletNavigationItem(
            destination: destinations[index],
            selected: index == selectedIndex,
            onTap: () {
              onDestinationSelected(index);
            },
          ),
      ],
    );
  }
}
