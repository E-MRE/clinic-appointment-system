part of 'auth_page.dart';

/// Shows the mobile back control for an auth form.
final class _AuthBackButton extends StatelessWidget {
  const _AuthBackButton({required this.kind, required this.canNavigate});

  final AuthFormKind kind;
  final bool canNavigate;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSizes.s8,
      children: [
        IconButton(
          tooltip: LocaleKeys.common_back.translate(),
          onPressed: canNavigate ? context.pop : null,
          icon: SquareSvgIcon(
            asset: Assets.images.auth.back,
            size: AppSizes.s24,
            color: context.colorScheme.onSurface,
          ),
        ),
        Expanded(
          child: Semantics(
            header: true,
            child: AppText.sectionTitle(kind.titleKey.translate()),
          ),
        ),
      ],
    );
  }
}
