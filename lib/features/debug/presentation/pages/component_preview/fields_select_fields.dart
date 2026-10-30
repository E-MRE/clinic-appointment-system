part of 'component_preview_page.dart';

/// Select field examples demonstrating normal, disabled and error states.
final class _FieldsSelectFields extends StatelessWidget {
  const _FieldsSelectFields();

  @override
  Widget build(BuildContext context) {
    final sample = LocaleKeys.componentPreview_sample.translate();
    final error = LocaleKeys.componentPreview_error.translate();
    final options = [AppSelectOption(value: sample, label: sample)];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s16,
      children: [
        _FieldsBasicSelectFields(sample: sample, options: options),
        _FieldsErrorSelectField(error: error, options: options),
      ],
    );
  }
}
