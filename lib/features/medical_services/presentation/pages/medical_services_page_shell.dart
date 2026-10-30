part of 'medical_services_page.dart';

/// Hosts the medical services responsive scaffold and layout.
final class _MedicalServicesPageShell extends StatelessWidget {
  const _MedicalServicesPageShell();

  @override
  Widget build(BuildContext context) {
    final isMobile = context.screenSize.isMobile;
    final branchId = InstitutionSelectionScope.of(context).branchId;

    return AppScaffold(
      floatingActionButton: isMobile && branchId != null
          ? const _MedicalServicesFab()
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _MedicalServicesHeader(),
          const EmptySize.s16Height(),
          Expanded(
            child: branchId == null
                ? const _MedicalServicesNoBranch()
                : const _MedicalServicesContent(),
          ),
        ],
      ),
    );
  }
}
