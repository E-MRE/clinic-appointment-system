part of 'component_preview_page.dart';

/// Text field examples demonstrating all input variants.
final class _FieldsTextFields extends StatelessWidget {
  const _FieldsTextFields({
    required this.normal,
    required this.disabled,
    required this.error,
    required this.helper,
  });

  final TextEditingController normal;
  final TextEditingController disabled;
  final TextEditingController error;
  final TextEditingController helper;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s16,
      children: [
        _FieldsBasicTextFields(normal: normal, disabled: disabled),
        _FieldsFeedbackTextFields(error: error, helper: helper),
      ],
    );
  }
}
