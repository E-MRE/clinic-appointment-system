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
            Container(
              color: switch (tone) {
                TextTone.onPrimary => context.colorScheme.primary,
                TextTone.onPrimaryContainer =>
                  context.colorScheme.primaryContainer,
                TextTone.onSecondaryContainer =>
                  context.colorScheme.secondaryContainer,
                TextTone.onTertiaryContainer =>
                  context.colorScheme.tertiaryContainer,
                TextTone.onError => context.colorScheme.error,
                TextTone.onErrorContainer => context.colorScheme.errorContainer,
                TextTone.onInverse => context.colorScheme.inverseSurface,
                TextTone.onBrand => context.brandColors.splashBackground,
                _ => context.colorScheme.surface,
              },
              child: AppText(
                '${role.name} / ${tone.name}',
                role: role,
                tone: tone,
              ),
            ),
      ],
    );
  }
}
