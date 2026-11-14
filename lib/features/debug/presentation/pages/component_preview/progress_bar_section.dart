part of 'component_preview_page.dart';

/// Shows the shared determinate progress bar with its active theme.
final class _ProgressBarSection extends StatelessWidget {
  const _ProgressBarSection();

  /// value = 0.68
  double get _sampleValue => 0.68;

  @override
  Widget build(BuildContext context) {
    final label = LocaleKeys.componentPreview_progressBar.translate();
    return AppSurface(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s8,
        children: [
          AppText.label(label),
          AppProgressBar(value: _sampleValue, semanticsLabel: label),
        ],
      ),
    );
  }
}
