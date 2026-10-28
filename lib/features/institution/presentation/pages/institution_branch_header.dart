part of 'institution_page.dart';

/// Branch heading and desktop add action.
final class _InstitutionBranchHeader extends StatelessWidget {
  const _InstitutionBranchHeader({required this.clinic});

  final Clinic clinic;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppText.sectionTitle(LocaleKeys.institution_branches.tr()),
        ),
        if (context.screenSize.isMobile == false)
          FilledButton.icon(
            onPressed: () => context.go(AppRoutes.branchNew(clinic.id)),
            icon: const Icon(Icons.add),
            label: AppText.label(
              LocaleKeys.institution_addBranch.tr(),
              tone: TextTone.onPrimary,
            ),
          ),
      ],
    );
  }
}
