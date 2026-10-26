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
  bool _obscured = true;

  String get _suffixTooltip =>
      (_obscured ? LocaleKeys.auth_showPassword : LocaleKeys.auth_hidePassword)
          .translate();

  @override
  Widget build(BuildContext context) {
    return _AuthTextField(
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
      prefixAsset: widget.showPrefix ? Assets.images.auth.lock : null,
      suffixIcon: _buildSuffix(context),
    );
  }

  IconButton _buildSuffix(BuildContext context) {
    return IconButton(
      iconSize: AppSizes.s20,
      tooltip: _suffixTooltip,
      onPressed: widget.enabled ? _toggleObscured : null,
      icon: _obscured
          ? SquareSvgIcon(
              asset: Assets.images.auth.eye,
              color: context.colorScheme.onSurfaceVariant,
              size: AppSizes.s20,
            )
          : const Icon(Icons.visibility_off_outlined, size: AppSizes.s20),
    );
  }

  void _toggleObscured() {
    setState(() {
      _obscured = !_obscured;
    });
  }
}
