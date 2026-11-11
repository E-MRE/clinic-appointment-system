part of 'staff_calendar_page.dart';

/// Single item in the calendar legend pairing a color swatch with a status label.
final class _StaffCalendarLegendItem extends StatelessWidget {
  const _StaffCalendarLegendItem({
    required this.label,
    required this.background,
    this.foreground,
    this.isDashed = false,
  });

  final String label;
  final Color background;
  final Color? foreground;
  final bool isDashed;

  /// Alpha multiplier softening the outline border of solid legend swatches.
  static const double _borderAlpha = 0.4;

  @override
  Widget build(BuildContext context) {
    final outlineColor = foreground ?? context.colorScheme.outlineVariant;

    final Widget swatch;
    if (isDashed && foreground != null) {
      swatch = AppDashedBorder(
        color: foreground!,
        strokeWidth: AppSizes.borderThin,
        radius: const AppRadius.xSmall(),
        child: Container(
          width: AppSizes.s16,
          height: AppSizes.s16,
          color: background,
        ),
      );
    } else {
      swatch = Container(
        width: AppSizes.s16,
        height: AppSizes.s16,
        decoration: BoxDecoration(
          color: background,
          borderRadius: const AppRadius.xSmall(),
          border: Border.all(
            color: outlineColor.withValues(alpha: _borderAlpha),
            width: AppSizes.borderThin,
          ),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        swatch,
        const EmptySize.s8Width(),
        AppText.caption(label, tone: TextTone.muted),
      ],
    );
  }
}
