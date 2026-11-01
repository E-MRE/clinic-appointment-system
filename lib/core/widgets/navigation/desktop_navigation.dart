part of 'app_navigation_shell.dart';

/// Desktop sidebar with application wordmark and optional primary action.
final class _DesktopNavigation extends StatelessWidget {
  const _DesktopNavigation({
    required this.logo,
    required this.destinations,
    required this.selectedIndex,
    required this.onDestinationSelected,
    required this.primaryAction,
    required this.footer,
  });

  final SvgGenImage logo;
  final List<AppNavigationDestination> destinations;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;
  final Widget? primaryAction;
  final Widget? footer;

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
            child: _NavigationItemList(
              destinations: destinations,
              selectedIndex: selectedIndex,
              onDestinationSelected: onDestinationSelected,
              itemBuilder: _DesktopNavigationItem.new,
            ),
          ),
          ?footer,
        ],
      ),
    );
  }
}
