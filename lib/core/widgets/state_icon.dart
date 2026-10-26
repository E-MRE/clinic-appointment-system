part of 'state_layout.dart';

/// Decorative state icon shown inside a themed shape.
final class _StateIcon extends StatelessWidget {
  const _StateIcon({
    required this.icon,
    required this.background,
    required this.size,
    required this.shape,
  });

  final Widget icon;
  final Color background;
  final double size;
  final StateIconShape shape;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: background, borderRadius: shape.radius),
      alignment: Alignment.center,
      child: ExcludeSemantics(child: icon),
    );
  }
}
