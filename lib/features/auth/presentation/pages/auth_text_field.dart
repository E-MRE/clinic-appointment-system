part of 'auth_page.dart';

/// Accessible external label and themed input shared by form variants.
final class _AuthTextField extends StatelessWidget {
  const _AuthTextField({
    required this.label,
    required this.controller,
    required this.enabled,
    required this.validator,
    this.fieldKey,
    this.hint,
    this.helper,
    this.keyboardType,
    this.autofillHints,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.prefixAsset,
    this.suffixIcon,
    this.obscureText = false,
  });

  final String label;
  final TextEditingController controller;
  final bool enabled;
  final String? Function(String?) validator;
  final Key? fieldKey;
  final String? hint;
  final String? helper;
  final TextInputType? keyboardType;
  final Iterable<String>? autofillHints;
  final TextInputAction textInputAction;
  final VoidCallback? onSubmitted;
  final SvgGenImage? prefixAsset;
  final Widget? suffixIcon;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s8,
      children: [
        ExcludeSemantics(
          child: Text(label, style: context.textTheme.labelLarge),
        ),
        Semantics(
          label: label,
          child: TextFormField(
            key: fieldKey,
            controller: controller,
            enabled: enabled,
            validator: validator,
            keyboardType: keyboardType,
            autofillHints: autofillHints,
            textInputAction: textInputAction,
            onFieldSubmitted: (_) => onSubmitted?.call(),
            obscureText: obscureText,
            autocorrect: false,
            enableSuggestions: false,
            style: context.textTheme.bodyLarge,
            decoration: _buildDecoration(context),
          ),
        ),
      ],
    );
  }

  InputDecoration _buildDecoration(BuildContext context) {
    return InputDecoration(
      fillColor: context.screenSize.isTablet
          ? context.colorScheme.surface
          : null,
      hintText: hint,
      helperText: helper,
      helperMaxLines: null,
      errorMaxLines: null,
      prefixIcon: _prefixIcon(context),
      suffixIcon: suffixIcon,
    );
  }

  Widget? _prefixIcon(BuildContext context) {
    final asset = prefixAsset;
    if (asset == null) {
      return null;
    }
    return SizedBox.square(
      dimension: AppSizes.s48,
      child: SquareSvgIcon(
        asset: asset,
        size: AppSizes.retryIcon,
        color: context.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
