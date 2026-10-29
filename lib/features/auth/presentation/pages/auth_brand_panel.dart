part of 'auth_page.dart';

/// Desktop brand surface, with its message separated from the page layout.
final class _AuthBrandPanel extends StatelessWidget {
  const _AuthBrandPanel({required this.kind});

  final AuthFormKind kind;

  @override
  Widget build(BuildContext context) {
    final brandColors = context.brandColors;
    return ColoredBox(
      color: brandColors.splashBackground,
      child: Padding(
        padding: const AppPadding.allXxxl(),
        child: ViewportScrollView(child: _AuthBrandPanelContent(kind: kind)),
      ),
    );
  }
}
