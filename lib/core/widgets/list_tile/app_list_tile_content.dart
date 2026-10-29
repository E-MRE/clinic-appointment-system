part of 'app_list_tile.dart';

/// Row layout and padding for a list tile.
final class _AppListTileContent extends StatelessWidget {
  const _AppListTileContent({
    required this.title,
    required this.subtitle,
    required this.leading,
    required this.trailing,
    required this.density,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final AppListTileDensity density;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: density.padding,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSizes.s48),
        child: Row(
          children: [
            if (leading case final leadingWidget?) ...[
              leadingWidget,
              const EmptySize.s12Width(),
            ],
            Expanded(
              child: _AppListTileText(title: title, subtitle: subtitle),
            ),
            if (trailing case final trailingWidget?) ...[
              const EmptySize.s12Width(),
              trailingWidget,
            ],
          ],
        ),
      ),
    );
  }
}
