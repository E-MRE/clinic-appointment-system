part of 'app_navigation_shell.dart';

/// Scrollable list of destinations drawn with the layout's own item widget.
final class _NavigationItemList extends StatelessWidget {
  const _NavigationItemList({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.itemBuilder,
  });

  final List<AppNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget Function({
    required AppNavigationDestination destination,
    required bool selected,
    required VoidCallback onTap,
  })
  itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const AppPadding.none(),
      children: [
        for (int index = 0; index < destinations.length; index++)
          itemBuilder(
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
