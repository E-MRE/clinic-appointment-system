part of 'component_preview_page.dart';

/// Single text preview sample colored by its role and tone.
final class _TextSectionSample extends StatelessWidget {
  const _TextSectionSample({required this.role, required this.tone});

  final TextRole role;
  final TextTone tone;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: switch (tone) {
        TextTone.onPrimary => context.colorScheme.primary,
        TextTone.onPrimaryContainer => context.colorScheme.primaryContainer,
        TextTone.onSecondaryContainer => context.colorScheme.secondaryContainer,
        TextTone.onTertiaryContainer => context.colorScheme.tertiaryContainer,
        TextTone.onError => context.colorScheme.error,
        TextTone.onErrorContainer => context.colorScheme.errorContainer,
        TextTone.onInverse => context.colorScheme.inverseSurface,
        TextTone.onBrand => context.brandColors.splashBackground,
        _ => context.colorScheme.surface,
      },
      child: AppText('${role.name} / ${tone.name}', role: role, tone: tone),
    );
  }
}
