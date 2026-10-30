part of 'radiology_form_section.dart';

/// Text field for configuring patient preparation instructions before radiology exams.
final class _RadiologyPreparationNoteField extends StatelessWidget
    with InstitutionInputValidationMixin, MedicalServiceInputValidationMixin {
  const _RadiologyPreparationNoteField();

  int get _noteLines => 3;

  @override
  Widget build(BuildContext context) {
    final formCubit = context.read<MedicalServiceFormCubit>();

    return AppTextField(
      label: LocaleKeys.services_preparationNote.tr(),
      initialValue: formCubit.state.preparationNote,
      onChanged: formCubit.changeNote,
      maxLines: _noteLines,
      maxLength: MedicalServiceConstants.maxPreparationNoteLength,
      validator: (value) => preparationNoteError(value ?? '')?.message,
    );
  }
}
