part of 'institution_page.dart';

/// Creates or renames a clinic in a focused name dialog.
final class _ClinicNameDialog extends StatefulWidget {
  const _ClinicNameDialog({required this.selection, this.clinic});

  final Clinic? clinic;
  final InstitutionSelection selection;

  @override
  State<_ClinicNameDialog> createState() => _ClinicNameDialogState();
}

final class _ClinicNameDialogState extends State<_ClinicNameDialog> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.clinic?.name);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ClinicSaveCubit>(
      create: (_) => AppDependency.injector.get<ClinicSaveCubit>(),
      child: BlocListener<ClinicSaveCubit, InstitutionSaveState<Clinic>>(
        listener: _onSaveState,
        child: AlertDialog(
          title: AppText.sectionTitle(
            widget.clinic == null
                ? LocaleKeys.institution_newClinic.tr()
                : LocaleKeys.institution_editClinic.tr(),
          ),
          content: _ClinicNameDialogContent(controller: controller),
          actions: [
            _ClinicNameDialogActions(
              clinic: widget.clinic,
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }

  void _onSaveState(BuildContext context, InstitutionSaveState<Clinic> state) {
    if (state is InstitutionSaveSaved<Clinic>) {
      widget.selection.selectClinic(state.value.id);
      Navigator.pop(context);
    }
  }
}
