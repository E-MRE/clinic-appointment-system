part of 'component_preview_page.dart';

/// Text field examples demonstrating normal and disabled states.
final class _FieldsBasicTextFields extends StatelessWidget {
  const _FieldsBasicTextFields({required this.normal, required this.disabled});

  final TextEditingController normal;
  final TextEditingController disabled;

  @override
  Widget build(BuildContext context) {
    final sample = LocaleKeys.componentPreview_sample.translate();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s16,
      children: [
        AppTextField(
          label: sample,
          controller: normal,
          prefixIconAsset: Assets.images.auth.email,
        ),
        AppTextField(
          label: LocaleKeys.componentPreview_disabled.translate(),
          controller: disabled,
          enabled: false,
        ),
      ],
    );
  }
}
