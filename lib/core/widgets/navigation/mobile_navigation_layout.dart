part of 'app_navigation_shell.dart';

/// Places mobile navigation below the current content.
final class _MobileNavigationLayout extends StatelessWidget {
  const _MobileNavigationLayout({required this.shell});

  final AppNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell.child,
      bottomNavigationBar: _MobileNavigation(
        destinations: shell.destinations,
        selectedIndex: shell.selectedIndex,
        onDestinationSelected: shell.onDestinationSelected,
      ),
    );
  }
}
