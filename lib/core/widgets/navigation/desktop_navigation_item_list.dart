part of 'app_navigation_shell.dart';

/// Scrollable list of destinations in the desktop navigation sidebar.
final class _DesktopNavigationItemList extends StatelessWidget {
  const _DesktopNavigationItemList({
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
          _DesktopNavigationItem(
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
