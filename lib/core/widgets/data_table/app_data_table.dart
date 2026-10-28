import 'dart:math' as math;

import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/data_table/app_table_column.dart';
import 'package:clinic_appointment_system/core/widgets/data_table/app_table_density.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface.dart';
import 'package:clinic_appointment_system/core/widgets/surface/app_surface_padding.dart';
import 'package:flutter/material.dart';

export 'app_table_alignment.dart';
export 'app_table_column.dart';
export 'app_table_density.dart';

part 'app_table_content.dart';
part 'app_table_cell.dart';
part 'app_table_scroll_view.dart';

/// A scrollable, content-sized table on a themed surface.
final class AppDataTable<T> extends StatelessWidget {
  /// Creates a table with feature-owned header and footer slots.
  const AppDataTable({
    required this.rows,
    required this.columns,
    required this.minWidth,
    this.density = AppTableDensity.regular,
    this.header,
    this.footer,
    this.rowVerticalPadding = AppSizes.s12,
    super.key,
  }) : assert(columns.length > 0),
       assert(minWidth >= 0),
       assert(rowVerticalPadding >= 0);

  /// Data displayed in order.
  final List<T> rows;

  /// Column definitions displayed in order.
  final List<AppTableColumn<T>> columns;

  /// Minimum width of the scrollable table.
  final double minWidth;

  /// Horizontal spacing and surface radius.
  final AppTableDensity density;

  /// Optional feature-owned content above the table.
  final Widget? header;

  /// Optional feature-owned content below the table.
  final Widget? footer;

  /// Vertical cell inset; use 8 for rows containing controls.
  final double rowVerticalPadding;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      radius: density.radius,
      padding: AppSurfacePadding.none,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          ?header,
          _AppTableScrollView<T>(
            rows: rows,
            columns: columns,
            minWidth: minWidth,
            density: density,
            rowVerticalPadding: rowVerticalPadding,
            hasHeader: header != null,
          ),
          ?footer,
        ],
      ),
    );
  }
}
