import 'package:flutter/widgets.dart';

/// Horizontal alignment of a table column.
enum AppTableAlignment {
  /// Aligns cells to the leading edge.
  start(alignment: AlignmentDirectional.centerStart),

  /// Aligns cells to the trailing edge.
  end(alignment: AlignmentDirectional.centerEnd);

  const AppTableAlignment({required this.alignment});

  /// Alignment used inside each cell.
  final AlignmentGeometry alignment;
}
