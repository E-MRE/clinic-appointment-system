part of 'app_navigation_shell.dart';

/// Places desktop navigation beside the current content.
final class _DesktopNavigationLayout extends StatelessWidget {
  const _DesktopNavigationLayout({required this.shell});

  final AppNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _DesktopNavigation(
          logo: shell.logo,
          destinations: shell.destinations,
          selectedIndex: shell.selectedIndex,
          onDestinationSelected: shell.onDestinationSelected,
          primaryAction: shell.primaryAction,
          footer: shell.footer,
        ),
        Expanded(child: shell.child),
      ],
    );
  }
}
