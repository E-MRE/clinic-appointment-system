part of 'staff_form.dart';

/// Selects the staff role while keeping existing account roles locked.
final class _StaffFormRoleControl extends StatelessWidget {
  const _StaffFormRoleControl({required this.isEditing});

  final bool isEditing;

  @override
  Widget build(BuildContext context) {
    final role = context.select<StaffFormCubit, UserRole>((c) => c.state.role);
    return AppSegmentedControl<UserRole>(
      choices: [
        AppChoice(
          value: UserRole.doctor,
          label: LocaleKeys.staff_roles_doctor.tr(),
        ),
        AppChoice(
          value: UserRole.technician,
          label: LocaleKeys.staff_roles_technician.tr(),
        ),
      ],
      selected: role,
      enabled: !isEditing,
      onSelected: context.read<StaffFormCubit>().selectRole,
    );
  }
}
