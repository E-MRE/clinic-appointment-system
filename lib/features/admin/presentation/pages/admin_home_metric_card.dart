part of 'admin_home_page.dart';

/// Displays one KPI using a shared tone-aware surface and text hierarchy.
final class _AdminHomeMetricCard extends StatelessWidget {
  const _AdminHomeMetricCard({
    required this.title,
    required this.value,
    required this.tone,
    this.caption,
  });

  final String title;
  final String value;
  final String? caption;
  final AdminMetricTone tone;

  @override
  Widget build(BuildContext context) {
    final captionText = caption;
    return SizedBox(
      height: AdminLayoutConstants.overviewMetricCardHeight,
      child: AppSurface(
        variant: tone.surfaceVariant,
        padding: AppSurfacePadding.comfortable,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText.label(
              title,
              color: tone.foreground(context),
              maxLines: AdminLayoutConstants.overviewMinimumColumnCount,
              overflow: TextOverflow.ellipsis,
            ),
            AppText.display(
              value,
              color: tone.foreground(context),
              maxLines: AdminLayoutConstants.overviewMinimumColumnCount,
              overflow: TextOverflow.ellipsis,
            ),
            if (captionText != null)
              AppText.caption(
                captionText,
                color: tone.captionColor(context),
                maxLines: AdminLayoutConstants.overviewMinimumColumnCount,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
