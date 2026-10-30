part of 'medical_services_page.dart';

/// Observes medical services from [MedicalServiceListCubit] and displays responsive content.
final class _MedicalServicesContent extends StatelessWidget {
  const _MedicalServicesContent();

  @override
  Widget build(BuildContext context) {
    return InstitutionListView<MedicalService, MedicalServiceListCubit>(
      emptyTitle: LocaleKeys.services_emptyTitle.tr(),
      emptyMessage: LocaleKeys.services_emptyMessage.tr(),
      onRetry: () {
        final branchId = InstitutionSelectionScope.read(context).branchId;
        if (branchId != null) {
          context.read<MedicalServiceListCubit>().watch(branchId);
        }
      },
      emptyAction: FilledButton.icon(
        onPressed: () => context.go(AppRoutes.serviceNew),
        icon: const Icon(Icons.add),
        label: AppText.label(
          LocaleKeys.services_addService.tr(),
          tone: TextTone.onPrimary,
        ),
      ),
      loadedBuilder: (services) => _MedicalServicesLoaded(services: services),
    );
  }
}
