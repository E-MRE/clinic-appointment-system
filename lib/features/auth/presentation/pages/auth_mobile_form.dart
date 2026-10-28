part of 'auth_page.dart';

/// Fills the mobile viewport with an auth form.
final class _AuthMobileForm extends StatelessWidget {
  const _AuthMobileForm({
    required this.kind,
    required this.canNavigate,
    required this.child,
  });

  final AuthFormKind kind;
  final bool canNavigate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: kind.formWidth),
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
