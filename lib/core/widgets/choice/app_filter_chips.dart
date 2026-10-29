import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_choice.dart';
import 'package:flutter/material.dart';

part 'filter_chip_item.dart';
part 'filter_chip_label.dart';
part 'filter_chip_style.dart';

/// Horizontally scrollable single-select filter chips.
final class AppFilterChips<T> extends StatelessWidget {
  /// Creates filter chips for the supplied choices.
  const AppFilterChips({
    required this.choices,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Choices in display order.
  final List<AppChoice<T>> choices;

  /// Currently selected value.
  final T selected;

  /// Called with the newly selected value.
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: AppSizes.s8,
        children: [
          for (final choice in choices)
            _FilterChip<T>(
              choice: choice,
              selected: choice.value == selected,
              onSelected: onSelected,
            ),
        ],
      ),
    );
  }
}
