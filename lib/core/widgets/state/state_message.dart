part of 'state_layout.dart';

/// State title and message with the live region semantics.
final class _StateMessage extends StatelessWidget {
  const _StateMessage({
    required this.title,
    required this.message,
    required this.maxWidth,
    required this.messageRole,
  });

  final String title;
  final String message;
  final double maxWidth;
  final TextRole messageRole;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: AppSizes.s8,
          children: [
            Semantics(
              header: true,
              child: AppText.headline(title, textAlign: TextAlign.center),
            ),
            AppText(
              message,
              role: messageRole,
              tone: TextTone.muted,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
