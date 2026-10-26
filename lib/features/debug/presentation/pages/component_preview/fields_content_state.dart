part of 'component_preview_page.dart';

/// Manages the form example controllers.
final class _FieldsContentState extends State<_FieldsContent> {
  final _normal = TextEditingController();
  final _disabled = TextEditingController();
  final _error = TextEditingController();
  final _helper = TextEditingController();
  @override
  void dispose() {
    _normal.dispose();
    _disabled.dispose();
    _error.dispose();
    _helper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sample = LocaleKeys.componentPreview_sample.translate();
    final error = LocaleKeys.componentPreview_error.translate();
    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s16,
        children: [
          AppTextField(
            label: sample,
            controller: _normal,
            prefixIconAsset: Assets.images.auth.email,
          ),
          AppTextField(
            label: LocaleKeys.componentPreview_disabled.translate(),
            controller: _disabled,
            enabled: false,
          ),
          AppTextField(
            label: error,
            controller: _error,
            validator: (_) {
              return error;
            },
          ),
          AppTextField(
            label: LocaleKeys.componentPreview_helper.translate(),
            controller: _helper,
            helper: LocaleKeys.componentPreview_helper.translate(),
          ),
          AppSelectField<String>(
            label: sample,
            options: [AppSelectOption(value: sample, label: sample)],
            onChanged: (_) {},
          ),
          AppSelectField<String>(
            label: LocaleKeys.componentPreview_disabled.translate(),
            options: [AppSelectOption(value: sample, label: sample)],
            onChanged: (_) {},
            enabled: false,
          ),
          AppSelectField<String>(
            label: error,
            options: [AppSelectOption(value: sample, label: sample)],
            onChanged: (_) {},
            validator: (_) {
              return error;
            },
          ),
        ],
      ),
    );
  }
}
