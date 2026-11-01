part of 'app_navigation_user_card.dart';

/// Adapts the shared avatar to the sidebar's identity colors and size.
final class _NavigationUserCardAvatar extends StatelessWidget {
  const _NavigationUserCardAvatar({required this.initials});
  final String initials;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Theme(
      data: context.theme.copyWith(
        colorScheme: scheme.copyWith(
          tertiaryContainer: scheme.secondaryContainer,
          onTertiaryContainer: scheme.onSecondaryContainer,
        ),
        textTheme: context.textTheme.copyWith(
          labelMedium: context.textTheme.titleMedium,
        ),
      ),
      child: AppAvatar(initials: initials),
    );
  }
}
