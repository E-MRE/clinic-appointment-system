part of 'app_data_table.dart';

/// Scrolls the table horizontally when its intrinsic width exceeds the viewport.
final class _AppTableScrollView<T> extends StatelessWidget {
  const _AppTableScrollView({
    required this.rows,
    required this.columns,
    required this.minWidth,
    required this.density,
    required this.rowVerticalPadding,
    required this.hasHeader,
  });

  final List<T> rows;
  final List<AppTableColumn<T>> columns;
  final double minWidth;
  final AppTableDensity density;
  final double rowVerticalPadding;
  final bool hasHeader;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: math.max(minWidth, constraints.maxWidth),
            ),
            child: IntrinsicWidth(
              child: _AppTableContent<T>(
                rows: rows,
                columns: columns,
                density: density,
                rowVerticalPadding: rowVerticalPadding,
                hasHeader: hasHeader,
              ),
            ),
          ),
        );
      },
    );
  }
}
