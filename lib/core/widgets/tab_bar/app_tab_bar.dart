import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:clinic_appointment_system/core/widgets/choice/app_choice.dart';
import 'package:clinic_appointment_system/core/widgets/tab_bar/app_tab_style_colors.dart';
import 'package:clinic_appointment_system/core/widgets/tab_bar/app_tab_style_selection.dart';
import 'package:flutter/material.dart';

part 'app_tab_bar_item.dart';

/// Underlined tab row selecting one value; scrolls when wider than its parent.
final class AppTabBar<T> extends StatelessWidget {
  /// Creates a tab row from labelled choices.
  const AppTabBar({
    required this.choices,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Tabs in display order.
  final List<AppChoice<T>> choices;

  /// Currently selected value.
  final T selected;

  /// Called with the newly selected value.
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const AppPadding.horizontalMd(),
      child: Row(
        spacing: AppSizes.s4,
        children: [
          for (final choice in choices)
            _AppTabBarItem<T>(
              choice: choice,
              isSelected: choice.value == selected,
              onSelected: onSelected,
            ),
        ],
      ),
    );
  }
}
