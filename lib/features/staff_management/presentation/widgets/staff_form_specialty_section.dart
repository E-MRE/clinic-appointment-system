part of 'staff_form.dart';

/// Delegates specialty inputs to the selected role's strategy.
final class _StaffFormSpecialtySection extends StatelessWidget {
  const _StaffFormSpecialtySection();

  @override
  Widget build(BuildContext context) {
    final role = context.select<StaffFormCubit, UserRole>((c) => c.state.role);
    return role.staffFormStrategy.specialtySection();
  }
}
