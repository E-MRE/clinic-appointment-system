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
        TableRow(
          decoration: hasHeader
              ? BoxDecoration(border: Border(top: border))
              : null,
          children: [
            for (var index = 0; index < columns.length; index++)
              _headerCell(columns[index], index),
          ],
        ),
        for (final row in rows)
          TableRow(
            decoration: BoxDecoration(border: Border(top: border)),
            children: [
              for (var index = 0; index < columns.length; index++)
                _rowCell(context, columns[index], row, index),
            ],
          ),
      ],
    );
  }

  Widget _headerCell(AppTableColumn<T> column, int index) {
    return _AppTableCell(
      padding: _padding(index, _headerVerticalPadding),
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

  Widget _rowCell(
    BuildContext context,
    AppTableColumn<T> column,
    T row,
    int index,
  ) {
    return _AppTableCell(
      padding: _padding(index, rowVerticalPadding),
      alignment: column.alignment.alignment,
      noWrap: column.noWrap,
      child: column.cellBuilder(context, row),
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
