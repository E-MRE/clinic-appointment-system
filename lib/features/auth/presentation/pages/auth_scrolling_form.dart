part of 'auth_page.dart';

/// Constrains an auth form in a scrollable viewport.
final class _AuthScrollingForm extends StatelessWidget {
  const _AuthScrollingForm({
    required this.kind,
    required this.canNavigate,
    required this.child,
  });

  final AuthFormKind kind;
  final bool canNavigate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ViewportScrollView(
      child: Center(
        child: Padding(
          padding: context.screenSize.select(
            mobile: const AppPadding.verticalLg(),
            tablet: const AppPadding.verticalXl(),
            desktop: const AppPadding.allXxl(),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.screenSize.isTablet
                  ? kind.config.cardWidth
                  : kind.config.formWidth,
            ),
            child: _AuthFormSurface(
              kind: kind,
              canNavigate: canNavigate,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
