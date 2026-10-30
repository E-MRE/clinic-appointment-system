part of 'component_preview_page.dart';

/// Owns the editable form examples.
final class _FieldsContent extends StatefulWidget {
  @override
  State<_FieldsContent> createState() {
    return _FieldsContentState();
  }
}

/// Manages the form example controllers.
final class _FieldsContentState extends State<_FieldsContent> {
  late final TextEditingController _normal;
  late final TextEditingController _disabled;
  late final TextEditingController _error;
  late final TextEditingController _helper;

  @override
  void initState() {
    super.initState();
    _normal = TextEditingController();
    _disabled = TextEditingController();
    _error = TextEditingController();
    _helper = TextEditingController();
  }

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
    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s16,
        children: [
          _FieldsTextFields(
            normal: _normal,
            disabled: _disabled,
            error: _error,
            helper: _helper,
          ),
          const _FieldsSelectFields(),
        ],
      ),
    );
  }
}
