part of 'medical_service_form.dart';

/// Text field for entering the medical service name with required validation.
final class _MedicalServiceFormNameField extends StatelessWidget
    with InstitutionInputValidationMixin, MedicalServiceInputValidationMixin {
  const _MedicalServiceFormNameField();

  @override
  Widget build(BuildContext context) {
    final formCubit = context.read<MedicalServiceFormCubit>();

    return AppTextField(
      label: LocaleKeys.services_name.tr(),
      initialValue: formCubit.state.name,
      onChanged: formCubit.changeName,
      validator: (value) => nameError(value ?? '')?.message,
    );
  }
}
