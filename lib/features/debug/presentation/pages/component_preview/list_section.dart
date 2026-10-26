part of 'component_preview_page.dart';

/// Displays list section samples.
final class _ListSection extends StatelessWidget {
  const _ListSection();
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSizes.s8,
      children: [
        for (final density in AppListTileDensity.values)
          AppSurface(
            child: AppListTile(
              title: density.name,
              subtitle: LocaleKeys.componentPreview_sample.translate(),
              density: density,
              leading: const AppAvatar(initials: 'EK'),
              trailing: StatusBadge(
                label: StatusBadgeVariant.info.name,
                variant: StatusBadgeVariant.info,
              ),
            ),
          ),
      ],
    );
  }
}
