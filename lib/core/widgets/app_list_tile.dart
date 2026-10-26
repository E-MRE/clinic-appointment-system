import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// Vertical spacing variants for a shared list row.
enum AppListTileDensity {
  /// Compact row padding.
  dense(AppPadding.listTileDense()),

  /// Standard row padding.
  regular(AppPadding.allLg());

  const AppListTileDensity(this.padding);

  /// Full padding around the row contents.
  final EdgeInsets padding;
}

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
            Expanded(child: _text(context)),
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

  Widget _text(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppText.bodyStrong(title, maxLines: 2, overflow: TextOverflow.ellipsis),
        if (subtitle case final subtitleText?)
          Padding(
            padding: const AppPadding.listTileSubtitle(),
            child: AppText.caption(
              subtitleText,
              tone: TextTone.muted,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }
}
