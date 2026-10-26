import 'package:clinic_appointment_system/core/widgets/data_table/app_table_alignment.dart';
import 'package:flutter/widgets.dart';

/// Defines the heading and cell content of a table column.
final class AppTableColumn<T> {
  /// Creates a column; an empty visible label requires a semantic label.
  const AppTableColumn({
    required this.label,
    required this.cellBuilder,
    this.semanticsLabel,
    this.alignment = AppTableAlignment.start,
    this.noWrap = false,
  }) : assert(label != '' || (semanticsLabel != null && semanticsLabel != ''));

  /// Visible header text, empty for an icon-only column.
  final String label;

  /// Accessible header text when the visible label is empty or needs context.
  final String? semanticsLabel;

  /// Horizontal alignment of the header and cells.
  final AppTableAlignment alignment;

  /// Prevents text in this column from wrapping at soft breaks.
  final bool noWrap;

  /// Builds the content for one row.
  final Widget Function(BuildContext, T) cellBuilder;
}
