part of 'staff_form.dart';

/// Groups the department heading and eligible service assignments.
final class _StaffFormServices extends StatelessWidget {
  const _StaffFormServices();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s8,
      children: [_StaffFormServicesHeading(), _StaffFormServiceOptions()],
    );
  }
}
