part of 'staff_form.dart';

/// Displays an editable temporary password with a regeneration action.
final class _StaffFormPasswordField extends StatelessWidget
    with AuthInputValidationMixin {
  const _StaffFormPasswordField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<StaffFormCubit>();
    return AppTextField(
      label: LocaleKeys.staff_temporaryPassword.tr(),
      hint: LocaleKeys.staff_passwordHint.tr(),
      controller: controller,
      onChanged: cubit.changePassword,
      validator: (value) => passwordError(value ?? '', isSignUp: true)?.message,
      suffix: IconButton(
        tooltip: LocaleKeys.staff_regeneratePassword.tr(),
        onPressed: cubit.regeneratePassword,
        icon: const Icon(Icons.refresh),
      ),
    );
  }
}
