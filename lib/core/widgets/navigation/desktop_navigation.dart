part of 'app_navigation_shell.dart';

/// Desktop sidebar with application wordmark and optional primary action.
final class _DesktopNavigation extends StatelessWidget {
  const _DesktopNavigation({
    required this.logo,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.primaryAction,
  });

  final SvgGenImage logo;
  final List<AppNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget? primaryAction;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSizes.navigationSidebar,
      color: context.colorScheme.surfaceContainer,
      padding: const AppPadding.allLg(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppBrandHeader(logo: logo, logoSize: AppSizes.s40),
          if (primaryAction case final action?) ...[
            const EmptySize.s24Height(),
            action,
          ],
          const EmptySize.s24Height(),
          Expanded(
            child: ListView(
              padding: const AppPadding.none(),
              children: [
                for (var index = 0; index < destinations.length; index++)
                  _DesktopNavigationItem(
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
    );
  }
}
