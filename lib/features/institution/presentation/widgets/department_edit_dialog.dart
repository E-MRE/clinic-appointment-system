part of 'department_section.dart';

/// Edits one department name and shows request feedback.
final class _DepartmentEditDialog extends StatefulWidget {
  const _DepartmentEditDialog({required this.item});

  final Department item;

  @override
  State<_DepartmentEditDialog> createState() => _DepartmentEditDialogState();
}

final class _DepartmentEditDialogState extends State<_DepartmentEditDialog> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.item.name);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentSaveCubit, InstitutionSaveState<Department>>(
      builder: (context, state) => AlertDialog(
        title: AppText.sectionTitle(LocaleKeys.institution_departments.tr()),
        content: _DepartmentEditContent(controller: controller, state: state),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: AppText.label(LocaleKeys.institution_cancel.tr()),
          ),
          FilledButton(
            onPressed: state is InstitutionSaveSaving<Department>
                ? null
                : _save,
            child: AppText.label(
              LocaleKeys.institution_save.tr(),
              tone: TextTone.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final save = context.read<DepartmentSaveCubit>();
    await save.update(widget.item, controller.text.trim());
    if (mounted && save.state is InstitutionSaveSaved<Department>) {
      Navigator.pop(context);
    }
  }
}
