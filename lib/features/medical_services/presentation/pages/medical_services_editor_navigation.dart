part of 'medical_services_page.dart';

/// Opens the medical service form in the editor that fits the screen size:
/// the side panel on desktop, a dialog on tablet and a page on mobile.
extension _MedicalServicesEditorNavigation on BuildContext {
  /// Opens the form for a new service in [branchId].
  void openServiceCreate(String branchId) {
    if (screenSize.isDesktop) {
      read<MedicalServiceEditorCubit>().startCreate();
    } else if (screenSize.isTablet) {
      _showServiceFormDialog(branchId: branchId);
    } else {
      go(AppRoutes.serviceNew);
    }
  }

  /// Opens the form for editing [service].
  void openServiceEdit(MedicalService service) {
    if (screenSize.isDesktop) {
      read<MedicalServiceEditorCubit>().edit(service);
    } else if (screenSize.isTablet) {
      _showServiceFormDialog(branchId: service.branchId, service: service);
    } else {
      go(AppRoutes.serviceEdit(service.id));
    }
  }

  /// The dialog route sits outside the page's provider tree, so the
  /// department list the form reads is provided to it again.
  Future<void> _showServiceFormDialog({
    required String branchId,
    MedicalService? service,
  }) {
    return showDialog<void>(
      context: this,
      builder: (_) {
        return BlocProvider<DepartmentListCubit>.value(
          value: read<DepartmentListCubit>(),
          child: _MedicalServiceFormDialog(
            branchId: branchId,
            service: service,
          ),
        );
      },
    );
  }
}
