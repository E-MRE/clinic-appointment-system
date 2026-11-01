part of 'app_navigation_user_card.dart';

/// Single-line identity text in the sidebar user card.
final class _NavigationUserCardIdentity extends StatelessWidget {
  const _NavigationUserCardIdentity({
    required this.name,
    required this.subtitle,
  });
  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText.bodyStrong(name, maxLines: 1, overflow: TextOverflow.ellipsis),
        AppText.caption(
          subtitle,
          tone: TextTone.muted,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
