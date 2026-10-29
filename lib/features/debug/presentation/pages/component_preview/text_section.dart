part of 'component_preview_page.dart';

/// Displays text section samples.
final class _TextSection extends StatelessWidget {
  const _TextSection();
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s12,
      children: [
        for (final role in TextRole.values)
          for (final tone in TextTone.values)
            _TextSectionSample(role: role, tone: tone),
      ],
    );
  }
}
