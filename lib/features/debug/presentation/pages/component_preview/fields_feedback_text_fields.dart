part of 'component_preview_page.dart';

/// Text field examples demonstrating error and helper text states.
final class _FieldsFeedbackTextFields extends StatelessWidget {
  const _FieldsFeedbackTextFields({required this.error, required this.helper});

  final TextEditingController error;
  final TextEditingController helper;

  @override
  Widget build(BuildContext context) {
    final errorText = LocaleKeys.componentPreview_error.translate();
    final helperText = LocaleKeys.componentPreview_helper.translate();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s16,
      children: [
        AppTextField(
          label: errorText,
          controller: error,
          validator: (_) => errorText,
        ),
        AppTextField(label: helperText, controller: helper, helper: helperText),
      ],
    );
  }
}
