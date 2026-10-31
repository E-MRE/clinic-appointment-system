part of 'staff_form.dart';

/// Toggles one eligible service and displays its formatted duration.
final class _StaffFormServiceTile extends StatelessWidget {
  const _StaffFormServiceTile({required this.service});

  final MedicalService service;

  @override
  Widget build(BuildContext context) {
    final selected = context.select<StaffFormCubit, bool>(
      (c) => c.state.serviceIds.contains(service.id),
    );
    return AppCheckboxTile(
      label: LocaleKeys.staff_serviceLabel.tr(
        args: [service.name, service.duration.formatted],
      ),
      value: selected,
      onChanged: (_) =>
          context.read<StaffFormCubit>().toggleService(service.id),
    );
  }
}
