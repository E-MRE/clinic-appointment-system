import 'package:flutter/widgets.dart';

/// Gives [child] at least the viewport height so it can center itself, and
/// scrolls it when it is taller (short screens, large text).
final class ViewportScrollView extends StatelessWidget {
  const ViewportScrollView({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: child,
      ),
    ),
  );
}
