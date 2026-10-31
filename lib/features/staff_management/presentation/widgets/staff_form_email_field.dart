part of 'staff_form.dart';

/// Validates a new account email and locks it for existing staff.
final class _StaffFormEmailField extends StatelessWidget
    with AuthInputValidationMixin {
  const _StaffFormEmailField({required this.isEditing});

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StaffFormCubit>();
    return AppTextField(
      label: LocaleKeys.staff_email.tr(),
      hint: LocaleKeys.staff_emailHint.tr(),
      initialValue: cubit.state.email,
      enabled: !isEditing,
      keyboardType: TextInputType.emailAddress,
      onChanged: cubit.changeEmail,
      validator: (value) => emailError(value ?? '')?.message,
    );
  }
}
