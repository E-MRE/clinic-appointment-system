part of 'app_data_table.dart';

/// Applies column alignment and text wrapping to a table cell.
final class _AppTableCell extends StatelessWidget {
  const _AppTableCell({
    required this.padding,
    required this.alignment,
    required this.noWrap,
    required this.child,
  });
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final bool noWrap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Align(
        alignment: alignment,
        child: DefaultTextStyle.merge(softWrap: !noWrap, child: child),
      ),
    );
  }
}
