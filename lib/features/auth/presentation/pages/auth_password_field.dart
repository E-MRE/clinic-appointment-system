part of 'auth_page.dart';

/// Owns password visibility without rebuilding or replacing its controller.
final class _AuthPasswordField extends StatefulWidget {
  const _AuthPasswordField({
    required this.label,
    required this.controller,
    required this.enabled,
    required this.validator,
    required this.fieldKey,
    required this.autofillHints,
    required this.textInputAction,
    required this.onSubmitted,
    this.helper,
    this.showPrefix = false,
  });
  final String label;
  final TextEditingController controller;
  final bool enabled;
  final String? Function(String?) validator;
  final Key fieldKey;
  final Iterable<String> autofillHints;
  final TextInputAction textInputAction;
  final VoidCallback? onSubmitted;
  final String? helper;
  final bool showPrefix;

  @override
  State<_AuthPasswordField> createState() {
    return _AuthPasswordFieldState();
  }
}

final class _AuthPasswordFieldState extends State<_AuthPasswordField> {
  late bool _obscured;

  @override
  void initState() {
    super.initState();
    _obscured = true;
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      controller: widget.controller,
      enabled: widget.enabled,
      validator: widget.validator,
      fieldKey: widget.fieldKey,
      autofillHints: widget.autofillHints,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      helper: widget.helper,
      obscureText: _obscured,
      prefixIconAsset: widget.showPrefix ? Assets.images.auth.lock : null,
      suffix: _AuthPasswordSuffix(
        obscured: _obscured,
        enabled: widget.enabled,
        onPressed: _toggleObscured,
      ),
    );
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }
}
