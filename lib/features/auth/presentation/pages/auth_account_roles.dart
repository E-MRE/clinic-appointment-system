part of 'auth_page.dart';

/// Explains which tasks each account role can perform.
final class _AuthAccountRoles extends StatelessWidget {
  const _AuthAccountRoles();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRoleItem(
          context,
          textKey: LocaleKeys.auth_patientDescription,
          asset: Assets.images.auth.patient,
        ),
        _buildRoleItem(
          context,
          textKey: LocaleKeys.auth_staffDescription,
          asset: Assets.images.auth.staff,
        ),
        _buildRoleItem(
          context,
          textKey: LocaleKeys.auth_adminDescription,
          asset: Assets.images.auth.admin,
        ),
      ],
    );
  }

  /// Builds a role row from its description and SVG asset.
  Widget _buildRoleItem(
    BuildContext context, {
    required String textKey,
    required SvgGenImage asset,
  }) {
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
