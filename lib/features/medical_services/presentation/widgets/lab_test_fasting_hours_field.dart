part of 'lab_test_form_section.dart';

/// Input field for configuring laboratory patient fasting duration requirements.
final class _LabTestFastingHoursField extends StatelessWidget
    with InstitutionInputValidationMixin, MedicalServiceInputValidationMixin {
  const _LabTestFastingHoursField();

  @override
  Widget build(BuildContext context) {
    final requiresFasting = context.select<MedicalServiceFormCubit, bool>(
      (c) => c.state.requiresFasting,
    );
    final formCubit = context.read<MedicalServiceFormCubit>();

    return AppTextField(
      label: LocaleKeys.services_fastingHoursLabel.tr(),
      hint: LocaleKeys.services_fastingHoursHint.tr(),
      enabled: requiresFasting,
      initialValue: formCubit.state.fastingText,
      onChanged: formCubit.changeFasting,
      validator: requiresFasting
          ? (value) => fastingInputError(value ?? '')?.message
          : null,
    );
  }
}
