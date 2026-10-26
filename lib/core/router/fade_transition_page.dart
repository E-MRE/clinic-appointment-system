import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

/// Route page that fades in when pushed and fades out when popped.
/// Pass the route's `pageKey` so stack changes keep the existing pages.
final class FadeTransitionPage<T> extends CustomTransitionPage<T> {
  const FadeTransitionPage({required super.child, super.key})
    : super(transitionsBuilder: _fade);

  static Widget _fade(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
      child: child,
    );
  }
}
