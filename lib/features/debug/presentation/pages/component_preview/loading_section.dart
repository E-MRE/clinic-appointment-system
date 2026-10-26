part of 'component_preview_page.dart';

/// Displays loading section samples.
final class _LoadingSection extends StatelessWidget {
  const _LoadingSection();
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSizes.s16,
      children: [
        for (final variant in LoadingStateVariant.values)
          AppSurface(
            child: Column(
              spacing: AppSizes.s8,
              children: [
                AppText.label(variant.name),
                LoadingState(
                  variant: variant,
                  label: LocaleKeys.common_loading.translate(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
