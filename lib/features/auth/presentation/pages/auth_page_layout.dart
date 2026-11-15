part of 'auth_page.dart';

/// Adapts the shared form to mobile, tablet card and desktop form-half layouts.
/// On desktop, [AuthShell] owns the brand panel beside this page.
final class _AuthPageLayout extends StatelessWidget {
  const _AuthPageLayout({
    required this.kind,
    required this.child,
    required this.canNavigate,
  });
  final AuthFormKind kind;
  final Widget child;
  final bool canNavigate;

  @override
  Widget build(BuildContext context) {
    if (context.screenSize.isDesktop) {
      return Scaffold(
        body: _AuthScrollingForm(
          kind: kind,
          canNavigate: canNavigate,
          child: child,
        ),
      );
    }
    return AppScaffold(
      child: context.screenSize.isMobile
          ? _buildMobileForm()
          : _AuthScrollingForm(
              kind: kind,
              canNavigate: canNavigate,
              child: child,
            ),
    );
  }

  /// Fills the mobile viewport with an auth form.
  Widget _buildMobileForm() {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: kind.config.formWidth),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: _AuthFormSurface(
                kind: kind,
                canNavigate: canNavigate,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
