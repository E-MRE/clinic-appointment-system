part of 'app_data_table.dart';

/// Data cell rendering a column cellBuilder for a table row.
final class _AppTableDataCell<T> extends StatelessWidget {
  const _AppTableDataCell({
    required this.column,
    required this.padding,
    required this.row,
  });

  final AppTableColumn<T> column;
  final EdgeInsetsGeometry padding;
  final T row;

  @override
  Widget build(BuildContext context) {
    return _AppTableCell(
      padding: padding,
      alignment: column.alignment.alignment,
      noWrap: column.noWrap,
      child: column.cellBuilder(context, row),
    );
  }
}
