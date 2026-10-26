part of 'component_preview_page.dart';

/// Displays states section samples.
final class _StatesSection extends StatelessWidget {
  const _StatesSection();
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: AppSizes.s16,
      children: [
        SizedBox(
          height: AppSizes.previewHeight,
          child: EmptyState(
            title: LocaleKeys.componentPreview_states.translate(),
            message: LocaleKeys.componentPreview_sample.translate(),
            icon: const Icon(Icons.inbox_outlined),
            iconBackground: context.colorScheme.secondaryContainer,
          ),
        ),
        SizedBox(
          height: AppSizes.previewHeight,
          child: ErrorState(
            title: LocaleKeys.componentPreview_error.translate(),
            message: LocaleKeys.componentPreview_sample.translate(),
            icon: const Icon(Icons.error_outline),
            iconBackground: context.colorScheme.errorContainer,
          ),
        ),
      ],
    );
  }
}
