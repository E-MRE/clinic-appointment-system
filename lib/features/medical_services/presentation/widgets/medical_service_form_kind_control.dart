part of 'medical_service_form.dart';

/// Segmented kind selector for examination, radiology and laboratory categories.
final class _MedicalServiceFormKindControl extends StatelessWidget {
  const _MedicalServiceFormKindControl({required this.isEditing});

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    final selectedKind = context
        .select<MedicalServiceFormCubit, MedicalServiceKind>(
          (c) => c.state.kind,
        );

    return AppSegmentedControl<MedicalServiceKind>(
      choices: _choices,
      selected: selectedKind,
      enabled: !isEditing,
      onSelected: context.read<MedicalServiceFormCubit>().selectKind,
    );
  }

  List<AppChoice<MedicalServiceKind>> get _choices {
    return [
      AppChoice(
        value: MedicalServiceKind.examination,
        label: LocaleKeys.services_kinds_examination.tr(),
      ),
      AppChoice(
        value: MedicalServiceKind.radiology,
        label: LocaleKeys.services_kinds_radiology.tr(),
      ),
      AppChoice(
        value: MedicalServiceKind.lab,
        label: LocaleKeys.services_kinds_lab.tr(),
      ),
    ];
  }
}
