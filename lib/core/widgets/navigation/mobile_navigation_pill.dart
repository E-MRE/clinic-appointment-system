part of 'app_navigation_shell.dart';

/// Background pill highlighting the selected navigation item on mobile.
final class _MobileNavigationPill extends StatelessWidget {
  const _MobileNavigationPill();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: context.colorScheme.secondaryContainer,
        borderRadius: const AppRadius.full(),
      ),
      child: const SizedBox.expand(),
    );
  }
}
