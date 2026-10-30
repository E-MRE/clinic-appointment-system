import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_choice.dart';
import 'package:clinic_appointment_system/core/widgets/choice/choice_style.dart';
import 'package:clinic_appointment_system/core/widgets/choice/choice_style_colors.dart';
import 'package:clinic_appointment_system/core/widgets/choice/choice_style_selection.dart';
import 'package:flutter/material.dart';

part 'segment_item.dart';
part 'segment_label.dart';

/// Outlined pill control for selecting one value from a short list.
final class AppSegmentedControl<T> extends StatelessWidget {
  /// Creates an outlined segmented control.
  const AppSegmentedControl({
    required this.choices,
    required this.selected,
    required this.onSelected,
    this.enabled = true,
    super.key,
  });

  /// Choices in display order.
  final List<AppChoice<T>> choices;

  /// Currently selected value.
  final T selected;

  /// Called with the newly selected value.
  final ValueChanged<T> onSelected;

  /// Whether user interaction is allowed.
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: scheme.outline, width: AppSizes.borderThin),
        borderRadius: const AppRadius.full(),
      ),
      padding: const AppPadding.segmentedControl(),
      child: Row(
        children: [
          for (final choice in choices)
            Expanded(
              child: _Segment<T>(
                choice: choice,
                selected: choice.value == selected,
                enabled: enabled,
                onSelected: onSelected,
              ),
            ),
        ],
      ),
    );
  }
}
