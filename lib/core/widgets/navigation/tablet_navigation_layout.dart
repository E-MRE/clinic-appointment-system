part of 'app_navigation_shell.dart';

/// Places tablet navigation beside the current content.
final class _TabletNavigationLayout extends StatelessWidget {
  const _TabletNavigationLayout({required this.shell});

  final AppNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _TabletNavigation(
          logo: shell.logo,
          destinations: shell.destinations,
          selectedIndex: shell.selectedIndex,
          onDestinationSelected: shell.onDestinationSelected,
        ),
        Expanded(child: shell.child),
      ],
    );
  }
}
