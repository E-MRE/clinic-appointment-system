part of 'staff_form.dart';

/// Edits the staff name using the domain's required-name rule.
final class _StaffFormNameField extends StatelessWidget
    with StaffInputValidationMixin {
  const _StaffFormNameField();

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StaffFormCubit>();
    return AppTextField(
      label: LocaleKeys.staff_fullName.tr(),
      hint: LocaleKeys.staff_fullNameHint.tr(),
      initialValue: cubit.state.fullName,
      onChanged: cubit.changeFullName,
      validator: (value) => staffFullNameError(value ?? '')?.staffMessage,
    );
  }
}
