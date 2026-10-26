part of 'app_navigation_shell.dart';

/// Mobile bottom navigation with selected pill indicators.
final class _MobileNavigation extends StatelessWidget {
  const _MobileNavigation({
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final List<AppNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: SizedBox(
        height: AppSizes.s80,
        child: Row(
          children: [
            for (var index = 0; index < destinations.length; index++)
              Expanded(
                child: _MobileNavigationItem(
                  destination: destinations[index],
                  selected: index == selectedIndex,
                  onTap: () {
                    onDestinationSelected(index);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
