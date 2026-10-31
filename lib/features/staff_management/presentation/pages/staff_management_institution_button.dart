part of 'staff_management_page.dart';

/// Opens institution management so the administrator can add a branch.
final class _StaffManagementInstitutionButton extends StatelessWidget {
  const _StaffManagementInstitutionButton();

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: () => context.go(AppRoutes.institution),
      child: AppText.label(
        LocaleKeys.staff_goToInstitution.tr(),
        tone: TextTone.onPrimary,
      ),
    );
  }
}
