part of 'auth_page.dart';

/// Toggles the visibility of one password field.
final class _AuthPasswordSuffix extends StatelessWidget {
  const _AuthPasswordSuffix({
    required this.obscured,
    required this.enabled,
    required this.onPressed,
  });

  final bool obscured;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: AppSizes.s20,
      tooltip:
          (obscured
                  ? LocaleKeys.auth_showPassword
                  : LocaleKeys.auth_hidePassword)
              .translate(),
      onPressed: enabled ? onPressed : null,
      icon: obscured
          ? SquareSvgIcon(
              asset: Assets.images.auth.eye,
              color: context.colorScheme.onSurfaceVariant,
              size: AppSizes.s20,
            )
          : const Icon(Icons.visibility_off_outlined, size: AppSizes.s20),
    );
  }
}
