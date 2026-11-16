part of 'admin_appointments_page.dart';

/// Selects a branch for the appointment filters.
final class _AdminAppointmentsFilterBranchField extends StatelessWidget {
  /// Creates a branch field from the current catalog and filter.
  const _AdminAppointmentsFilterBranchField({
    required this.filter,
    required this.catalog,
  });

  final AdminAppointmentFilter filter;
  final ClinicCatalog catalog;

  @override
  Widget build(BuildContext context) {
    return AppSelectField<String?>(
      label: LocaleKeys.admin_appointmentsPage_branch.translate(),
      hint: LocaleKeys.admin_appointmentsPage_allBranches.translate(),
      value: filter.branchId,
      highlightSelection: true,
      options: [
        AppSelectOption<String?>(
          value: null,
          label: LocaleKeys.admin_appointmentsPage_allBranches.translate(),
        ),
        for (final branch in filter.branchesIn(catalog))
          AppSelectOption<String?>(value: branch.id, label: branch.name),
      ],
      onChanged: (branchId) {
        context.read<AdminAppointmentsCubit>().selectBranch(branchId, catalog);
      },
    );
  }
}
