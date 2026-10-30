part of 'medical_services_page.dart';

/// Empty state presented when no branch exists or is selected in the institution scope.
final class _MedicalServicesNoBranch extends StatelessWidget {
  const _MedicalServicesNoBranch();

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      title: LocaleKeys.services_noBranchTitle.tr(),
      message: LocaleKeys.services_noBranchMessage.tr(),
      icon: const Icon(Icons.domain_outlined),
      iconBackground: context.colorScheme.surfaceContainerHighest,
      primaryAction: FilledButton(
        onPressed: () => context.go(AppRoutes.institution),
        child: AppText.label(
          LocaleKeys.services_goToInstitution.tr(),
          tone: TextTone.onPrimary,
        ),
      ),
    );
  }
}
