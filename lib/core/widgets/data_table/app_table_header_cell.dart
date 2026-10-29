part of 'app_data_table.dart';

/// Header cell wrapping column label and semantic heading.
final class _AppTableHeaderCell<T> extends StatelessWidget {
  const _AppTableHeaderCell({required this.column, required this.padding});

  final AppTableColumn<T> column;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return _AppTableCell(
      padding: padding,
      alignment: column.alignment.alignment,
      noWrap: column.noWrap,
      child: Semantics(
        header: true,
        label: column.semanticsLabel ?? column.label,
        excludeSemantics: true,
        child: AppText.badge(column.label, tone: TextTone.muted),
      ),
    );
  }
}
