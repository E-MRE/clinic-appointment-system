part of 'staff_calendar_page.dart';

/// A solid or dashed legend marker using the item's status colors.
final class _StaffCalendarLegendSwatch extends StatelessWidget {
  const _StaffCalendarLegendSwatch({
    required this.background,
    required this.foreground,
    required this.isDashed,
  });

  final Color background;
  final Color? foreground;
  final bool isDashed;

  /// Alpha multiplier softening the outline border of solid legend swatches.
  double get _borderAlpha => 0.4;

  @override
  Widget build(BuildContext context) {
    final outlineColor = foreground ?? context.colorScheme.outlineVariant;

    if (isDashed) {
      final swatchForeground = foreground;
      if (swatchForeground != null) {
        return AppDashedBorder(
          color: swatchForeground,
          strokeWidth: AppSizes.borderThin,
          radius: const AppRadius.xSmall(),
          child: Container(
            width: AppSizes.s16,
            height: AppSizes.s16,
            color: background,
          ),
        );
      }
    }

    return Container(
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
}
