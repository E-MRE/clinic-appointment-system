part of 'component_preview_page.dart';

/// Normal and disabled select field examples.
final class _FieldsBasicSelectFields extends StatelessWidget {
  const _FieldsBasicSelectFields({required this.sample, required this.options});

  final String sample;
  final List<AppSelectOption<String>> options;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s16,
      children: [
        AppSelectField<String>(
          label: sample,
          options: options,
          onChanged: (_) {},
        ),
        AppSelectField<String>(
          label: LocaleKeys.componentPreview_disabled.translate(),
          options: options,
          onChanged: (_) {},
          enabled: false,
        ),
      ],
    );
  }
}
