part of 'institution_page.dart';

/// Mobile add-branch floating action.
final class _InstitutionMobileAddBranch extends StatelessWidget {
  const _InstitutionMobileAddBranch({required this.clinic});

  final Clinic clinic;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: FloatingActionButton.extended(
        onPressed: () => context.go(AppRoutes.branchNew(clinic.id)),
        icon: const Icon(Icons.add),
        label: AppText.label(
          LocaleKeys.institution_addBranch.tr(),
          tone: TextTone.onPrimary,
        ),
      ),
    );
  }
}
