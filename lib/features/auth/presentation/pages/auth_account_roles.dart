part of 'auth_page.dart';

/// Explains which tasks each account role can perform.
final class _AuthAccountRoles extends StatelessWidget {
  const _AuthAccountRoles();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AuthRoleItem(
          textKey: LocaleKeys.auth_patientDescription,
          asset: Assets.images.auth.patient,
        ),
        _AuthRoleItem(
          textKey: LocaleKeys.auth_staffDescription,
          asset: Assets.images.auth.staff,
        ),
        _AuthRoleItem(
          textKey: LocaleKeys.auth_adminDescription,
          asset: Assets.images.auth.admin,
        ),
      ],
    );
  }
}
