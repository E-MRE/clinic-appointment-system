part of 'auth_page.dart';

/// Adds the responsive surface around an auth form.
final class _AuthFormSurface extends StatelessWidget {
  const _AuthFormSurface({
    required this.kind,
    required this.canNavigate,
    required this.child,
  });

  final AuthFormKind kind;
  final bool canNavigate;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (context.screenSize.isMobile && kind.config.offersBack)
          _AuthBackButton(kind: kind, canNavigate: canNavigate),
        if (context.screenSize.isMobile) Expanded(child: child) else child,
      ],
    );
    if (context.screenSize.isTablet) {
      return Card(
        child: Padding(padding: const AppPadding.authCard(), child: content),
      );
    }
    return content;
  }
}
