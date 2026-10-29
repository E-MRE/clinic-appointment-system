part of 'component_preview_page.dart';

/// Error select field example with validator.
final class _FieldsErrorSelectField extends StatelessWidget {
  const _FieldsErrorSelectField({required this.error, required this.options});

  final String error;
  final List<AppSelectOption<String>> options;

  @override
  Widget build(BuildContext context) {
    return AppSelectField<String>(
      label: error,
      options: options,
      onChanged: (_) {},
      validator: (_) => error,
    );
  }
}
