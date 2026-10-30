part of 'auth_page.dart';

/// Title and description texts in auth heading.
final class _AuthHeadingTexts extends StatelessWidget {
  const _AuthHeadingTexts({required this.kind, required this.centered});

  final AuthFormKind kind;
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final size = context.screenSize;
    return Column(
      crossAxisAlignment: centered
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (!size.isMobile || !kind.offersBack)
          Semantics(
            header: true,
            child: AppText.headline(kind.titleKey.translate()),
          ),
        const EmptySize.s8Height(),
        AppText.body(
          kind.descriptionKeyFor(size).translate(),
          textAlign: centered ? TextAlign.center : TextAlign.start,
          tone: TextTone.muted,
        ),
      ],
    );
  }
}
