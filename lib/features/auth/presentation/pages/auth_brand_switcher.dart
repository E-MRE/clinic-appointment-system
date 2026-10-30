part of 'auth_page.dart';

/// Animated switcher holding the auth brand message.
final class _AuthBrandSwitcher extends StatelessWidget {
  const _AuthBrandSwitcher({required this.kind});

  final AuthFormKind kind;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: AnimatedSwitcher(
        duration: kThemeAnimationDuration,
        child: _AuthBrandMessage(key: ValueKey(kind.brandTitleKey), kind: kind),
      ),
    );
  }
}
