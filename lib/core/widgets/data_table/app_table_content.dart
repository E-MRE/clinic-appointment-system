part of 'app_data_table.dart';

/// Lays out intrinsic columns and horizontal row borders.
final class _AppTableContent<T> extends StatelessWidget {
  const _AppTableContent({
    required this.rows,
    required this.columns,
    required this.density,
    required this.rowVerticalPadding,
    required this.hasHeader,
  });
  final List<T> rows;
  final List<AppTableColumn<T>> columns;
  final AppTableDensity density;
  final double rowVerticalPadding;
  final bool hasHeader;

  @override
  Widget build(BuildContext context) {
    final border = BorderSide(
      color: context.colorScheme.outlineVariant,
      width: AppSizes.borderThin,
    );
    return Table(
      defaultColumnWidth: const IntrinsicColumnWidth(flex: 1),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        _headerRow(border),
        for (final row in rows) _dataRow(row, border),
      ],
    );
  }

  TableRow _headerRow(BorderSide border) {
    return TableRow(
      decoration: hasHeader ? BoxDecoration(border: Border(top: border)) : null,
      children: [
        for (int index = 0; index < columns.length; index++)
          _AppTableHeaderCell(
            column: columns[index],
            padding: _padding(index, _headerVerticalPadding),
          ),
      ],
    );
  }

  TableRow _dataRow(T row, BorderSide border) {
    return TableRow(
      decoration: BoxDecoration(border: Border(top: border)),
      children: [
        for (int index = 0; index < columns.length; index++)
          _AppTableDataCell(
            column: columns[index],
            padding: _padding(index, rowVerticalPadding),
            row: row,
          ),
      ],
    );
  }

  EdgeInsetsGeometry _padding(int index, double vertical) {
    return EdgeInsetsDirectional.only(
      start: _horizontalPadding(_isFirst(index)),
      end: _horizontalPadding(_isLast(index)),
      top: vertical,
      bottom: vertical,
    );
  }

  /// Header cell vertical padding = 12.
  double get _headerVerticalPadding => AppSizes.s12;

  bool _isFirst(int index) => index == 0;

  bool _isLast(int index) => index == columns.length - 1;

  double _horizontalPadding(bool edge) =>
      edge ? density.outerPadding : density.middlePadding;
}
