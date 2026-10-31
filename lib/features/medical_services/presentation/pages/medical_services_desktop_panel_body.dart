part of 'medical_services_page.dart';

/// Form content and title within the desktop side panel.
final class _MedicalServicesDesktopPanelBody extends StatelessWidget {
  const _MedicalServicesDesktopPanelBody();

  @override
  Widget build(BuildContext context) {
    final editorState = context.watch<MedicalServiceEditorCubit>().state;
    final branchId = InstitutionSelectionScope.of(context).branchId;
    final title = editorState.isEditing
        ? LocaleKeys.services_editService.tr()
        : LocaleKeys.services_addService.tr();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppText.sectionTitle(title),
        const EmptySize.s16Height(),
        MedicalServiceForm(
          key: ValueKey<int>(editorState.revision),
          service: editorState.record,
          branchId: branchId,
          onSaved: (_) {
            context.read<MedicalServiceEditorCubit>().startCreate();
          },
        ),
      ],
    );
  }
}
