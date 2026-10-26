part of 'auth_page.dart';

/// Wraps account navigation and explains patient-only registration.
final class _AuthFormFooter extends StatelessWidget {
  const _AuthFormFooter({required this.kind, required this.enabled});

  final AuthFormKind kind;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final centered = !context.screenSize.isDesktop;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!context.screenSize.isMobile) ...[
          const Divider(),
          const EmptySize.s24Height(),
        ],
        _AuthAccountLink(
          footer: kind.footer,
          enabled: enabled,
          centered: centered,
        ),
        if (kind.showsStaffNotice) _staffNotice(context, centered),
      ],
    );
  }

  Widget _staffNotice(BuildContext context, bool centered) {
    return AppText.caption(
      LocaleKeys.auth_staffNotice.translate(),
      textAlign: centered ? TextAlign.center : TextAlign.start,
      tone: TextTone.muted,
    );
  }
}
