part of 'auth_page.dart';

/// Identifies an account role with its supplied SVG asset.
final class _AuthRoleItem extends StatelessWidget {
  const _AuthRoleItem({required this.textKey, required this.asset});

  final SvgGenImage asset;
  final String textKey;

  @override
  Widget build(BuildContext context) {
    return _AuthBrandItem(
      textKey: textKey,
      leading: SquareSvgIcon(
        asset: asset,
        size: AppSizes.retryIcon,
        color: context.colorScheme.onPrimary,
      ),
    );
  }
}
