import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/list_tile/app_list_tile_density.dart';
import 'package:flutter/material.dart';

export 'package:clinic_appointment_system/core/widgets/list_tile/app_list_tile_density.dart';

part 'app_list_tile_text.dart';

/// Shared list row with optional leading and trailing content.
final class AppListTile extends StatelessWidget {
  /// Creates a row from display values and optional widgets.
  const AppListTile({
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.density = AppListTileDensity.regular,
    this.onTap,
    super.key,
  });

  /// Primary row title.
  final String title;

  /// Optional muted secondary text.
  final String? subtitle;

  /// Optional avatar, time or icon widget.
  final Widget? leading;

  /// Optional badge or action widget.
  final Widget? trailing;

  /// Row vertical spacing variant.
  final AppListTileDensity density;

  /// Optional row tap callback.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: density.padding,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSizes.s48),
        child: Row(
          children: [
            if (leading case final leadingWidget?) ...[
              leadingWidget,
              const EmptySize.s12Width(),
            ],
            Expanded(
              child: _AppListTileText(title: title, subtitle: subtitle),
            ),
            if (trailing case final trailingWidget?) ...[
              const EmptySize.s12Width(),
              trailingWidget,
            ],
          ],
        ),
      ),
    );
    return Semantics(
      button: onTap != null,
      child: InkWell(onTap: onTap, child: content),
    );
  }
}
