part of 'component_preview_page.dart';

/// Selects a labelled preview option.
final class _PreviewSelector<T extends Enum> extends StatelessWidget {
  const _PreviewSelector({
    required this.values,
    required this.selected,
    required this.label,
    required this.onChanged,
  });

  final List<T> values;
  final T selected;
  final String Function(T) label;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: selected,
      items: [
        for (final value in values)
          DropdownMenuItem(value: value, child: Text(label(value).translate())),
      ],
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}
