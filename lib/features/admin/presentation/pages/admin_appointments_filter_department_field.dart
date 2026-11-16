part of 'admin_appointments_page.dart';

/// Selects a department for the appointment filters.
final class _AdminAppointmentsFilterDepartmentField extends StatelessWidget {
  /// Creates a department field from the current catalog and filter.
  const _AdminAppointmentsFilterDepartmentField({
    required this.filter,
    required this.catalog,
  });

  final AdminAppointmentFilter filter;
  final ClinicCatalog catalog;

  @override
  Widget build(BuildContext context) {
    return AppSelectField<String?>(
      label: LocaleKeys.admin_appointmentsPage_department.translate(),
      hint: LocaleKeys.admin_appointmentsPage_allDepartments.translate(),
      value: filter.departmentId,
      highlightSelection: true,
      options: [
        AppSelectOption<String?>(
          value: null,
          label: LocaleKeys.admin_appointmentsPage_allDepartments.translate(),
        ),
        for (final department in filter.departmentsIn(catalog))
          AppSelectOption<String?>(
            value: department.id,
            label: department.name,
          ),
      ],
      onChanged: (departmentId) {
        context.read<AdminAppointmentsCubit>().selectDepartment(
          departmentId,
          catalog,
        );
      },
    );
  }
}
