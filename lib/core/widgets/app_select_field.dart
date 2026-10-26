import 'package:clinic_appointment_system/core/theme/theme.dart';
import 'package:clinic_appointment_system/core/widgets/app_text.dart';
import 'package:flutter/material.dart';

/// A display option for [AppSelectField].
final class AppSelectOption<T> {
  /// Creates an option from a typed value and its visible label.
  const AppSelectOption({required this.value, required this.label});

  /// Value passed to the selection callback.
  final T value;

  /// Visible option text.
  final String label;
}

/// Labeled themed select field backed by display options.
final class AppSelectField<T> extends StatelessWidget {
  /// Creates a select field with a caller supplied options list.
  const AppSelectField({
    required this.label,
    required this.options,
    required this.onChanged,
    this.value,
    this.hint,
    this.enabled = true,
    this.validator,
    this.fieldKey,
    super.key,
  });

  /// Accessible field label.
  final String label;

  /// Display options to choose from.
  final List<AppSelectOption<T>> options;

  /// Optional selected value.
  final T? value;

  /// Invoked when a different option is selected.
  final ValueChanged<T?> onChanged;

  /// Optional placeholder text.
  final String? hint;

  /// Whether the field accepts input.
  final bool enabled;

  /// Optional form validation behavior.
  final String? Function(T?)? validator;

  /// Optional key for the underlying form field.
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExcludeSemantics(child: AppText.label(label)),
        const EmptySize.s8Height(),
        Semantics(
          label: label,
          child: KeyedSubtree(
            key: fieldKey,
            child: DropdownButtonFormField<T>(
              key: ValueKey<T?>(value),
              initialValue: value,
              isExpanded: true,
              hint: hint == null ? null : AppText.body(hint!),
              items: options
                  .map(
                    (option) => DropdownMenuItem<T>(
                      value: option.value,
                      child: AppText.body(option.label),
                    ),
                  )
                  .toList(),
              onChanged: enabled ? onChanged : null,
              validator: validator,
              decoration: const InputDecoration(),
            ),
          ),
        ),
      ],
    );
  }
}
