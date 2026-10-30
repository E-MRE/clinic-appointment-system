part of 'medical_services_page.dart';

/// Observes medical services from [MedicalServiceListCubit] and displays responsive content.
final class _MedicalServicesContent extends StatelessWidget {
  const _MedicalServicesContent();

  @override
  Widget build(BuildContext context) {
    return _MedicalServicesDesktopLayout(
      child: InstitutionListView<MedicalService, MedicalServiceListCubit>(
        emptyTitle: LocaleKeys.services_emptyTitle.tr(),
        emptyMessage: LocaleKeys.services_emptyMessage.tr(),
        onRetry: () {
          final branchId = InstitutionSelectionScope.read(context).branchId;
          if (branchId != null) {
            context.read<MedicalServiceListCubit>().watch(branchId);
          }
        },
        emptyAction: _emptyAction(context),
        loadedBuilder: (services) => _MedicalServicesLoaded(services: services),
      ),
    );
  }

  /// The desktop panel already shows the create form, so the empty state
  /// offers an add action only on smaller screens.
  Widget? _emptyAction(BuildContext context) {
    if (context.screenSize.isDesktop) return null;
    return FilledButton.icon(
      onPressed: () => _onAdd(context),
      icon: const Icon(Icons.add),
      label: AppText.label(
        LocaleKeys.services_addService.tr(),
        tone: TextTone.onPrimary,
      ),
    );
  }

  void _onAdd(BuildContext context) {
    final branchId = InstitutionSelectionScope.read(context).branchId;
    if (branchId != null) context.openServiceCreate(branchId);
  }
}
