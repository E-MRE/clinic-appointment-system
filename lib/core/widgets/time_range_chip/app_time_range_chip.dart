import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/time_range_chip/app_time_range_chip_variant.dart';
import 'package:clinic_appointment_system/core/widgets/time_range_chip/app_time_range_chip_variant_colors.dart';
import 'package:flutter/material.dart';

export 'app_time_range_chip_variant.dart';

/// Displays a time range and an optional remove action.
final class AppTimeRangeChip extends StatelessWidget {
  /// Creates a range chip.
  const AppTimeRangeChip({
    required this.label,
    required this.removeTooltip,
    required this.onRemove,
    this.variant = AppTimeRangeChipVariant.standard,
    super.key,
  });
  final String label;
  final String removeTooltip;
  final VoidCallback? onRemove;
  final AppTimeRangeChipVariant variant;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Semantics(
      hint: variant.semanticsHint,
      child: Container(
        height: AppSizes.s32,
        padding: const AppPadding.removableChip(),
        decoration: BoxDecoration(
          color: variant.background(scheme),
          borderRadius: const AppRadius.small(),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.label(label, tone: variant.tone),
            if (onRemove != null) ...[
              const EmptySize.s2Width(),
              SizedBox.square(
                dimension: AppSizes.timeRangeRemoveButton,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: removeTooltip,
                  onPressed: onRemove,
                  icon: Icon(
                    Icons.close,
                    size: AppSizes.timeRangeRemoveIcon,
                    color: variant.foreground(scheme),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
