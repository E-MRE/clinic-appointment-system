part of 'app_navigation_shell.dart';

/// Compact error-colored count badge used by navigation destinations.
final class _NavigationCountBadge extends StatelessWidget {
  const _NavigationCountBadge({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const AppPadding.horizontalXs(),
      decoration: BoxDecoration(
        color: context.colorScheme.error,
        borderRadius: const AppRadius.full(),
      ),
      child: AppText.badge('$count', tone: TextTone.onError),
    );
  }
}
