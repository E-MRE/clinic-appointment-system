part of 'component_preview_page.dart';

/// Displays status section samples.
final class _StatusSection extends StatelessWidget {
  const _StatusSection();
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSizes.s8,
      runSpacing: AppSizes.s8,
      children: [
        for (final variant in StatusBadgeVariant.values)
          StatusBadge(label: variant.name, variant: variant),
      ],
    );
  }
}
