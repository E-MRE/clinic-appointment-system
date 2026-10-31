part of 'app_data_table.dart';

/// Scrolls the table horizontally when its intrinsic width exceeds the
/// viewport, keeping the scrollbar visible so the overflow is discoverable.
/// Bottom padding reserves the scrollbar's track so it never covers a row.
final class _AppTableScrollView<T> extends StatefulWidget {
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
  State<_AppTableScrollView<T>> createState() => _AppTableScrollViewState<T>();
}

final class _AppTableScrollViewState<T> extends State<_AppTableScrollView<T>> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          controller: _controller,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: _controller,
            scrollDirection: Axis.horizontal,
            padding: const AppPadding.tableScrollbar(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: math.max(widget.minWidth, constraints.maxWidth),
              ),
              child: IntrinsicWidth(
                child: _AppTableContent<T>(
                  rows: widget.rows,
                  columns: widget.columns,
                  density: widget.density,
                  rowVerticalPadding: widget.rowVerticalPadding,
                  hasHeader: widget.hasHeader,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
