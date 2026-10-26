part of 'startup_error_page.dart';

/// Title and description, announced together when they appear.
final class _StartupErrorMessage extends StatelessWidget {
  const _StartupErrorMessage({required this.kind});
  final StartupErrorKind kind;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme;
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: AppSizes.messageMaxWidth),
      child: Semantics(
        liveRegion: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSizes.s8,
          children: [
            Semantics(
              header: true,
              child: Text(
                kind.titleKey.translate(),
                style: textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              kind.descriptionKey.translate(),
              style: textTheme.bodyMedium?.copyWith(
                color: context.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
