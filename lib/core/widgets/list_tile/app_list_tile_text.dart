part of 'app_list_tile.dart';

/// Shows the title and optional subtitle of a list row.
final class _AppListTileText extends StatelessWidget {
  const _AppListTileText({required this.title, required this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText.bodyStrong(title, maxLines: 2, overflow: TextOverflow.ellipsis),
        if (subtitle case final subtitleText?)
          Padding(
            padding: const AppPadding.listTileSubtitle(),
            child: AppText.caption(
              subtitleText,
              tone: TextTone.muted,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
