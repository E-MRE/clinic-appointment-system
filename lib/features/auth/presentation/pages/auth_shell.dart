part of 'auth_page.dart';

/// Keeps the desktop brand panel in place while auth forms change beside it.
/// Mobile and tablet forms own the full screen, so the shell adds nothing.
final class AuthShell extends StatelessWidget {
  const AuthShell({required this.kind, required this.child, super.key});

  /// Variant whose brand message the panel shows.
  final AuthFormKind kind;

  /// Nested navigator holding the auth form pages.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (!context.screenSize.isDesktop) {
      return child;
    }
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _AuthBrandPanel(kind: kind)),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
