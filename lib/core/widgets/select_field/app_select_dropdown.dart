part of 'app_select_field.dart';

/// Wrapped dropdown button form field for select input.
final class _AppSelectDropdown<T> extends StatelessWidget {
  const _AppSelectDropdown({
    required this.label,
    required this.options,
    required this.onChanged,
    required this.value,
    required this.hint,
    required this.enabled,
    required this.validator,
    required this.fieldKey,
  });

  final String label;
  final List<AppSelectOption<T>> options;
  final ValueChanged<T?> onChanged;
  final T? value;
  final String? hint;
  final bool enabled;
  final String? Function(T?)? validator;
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: label,
      child: KeyedSubtree(
        key: fieldKey,
        child: DropdownButtonFormField<T>(
          key: ValueKey<T?>(value),
          initialValue: value,
          isExpanded: true,
          hint: switch (hint) {
            final text? => AppText.body(text),
            null => null,
          },
          items: _items,
          onChanged: enabled ? onChanged : null,
          validator: validator,
          decoration: const InputDecoration(),
        ),
      ),
    );
  }

  List<DropdownMenuItem<T>> get _items {
    return [
      for (final option in options)
        DropdownMenuItem<T>(
          value: option.value,
          child: AppText.body(option.label),
        ),
    ];
  }
}
