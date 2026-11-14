part of 'admin_appointments_page.dart';

/// Lays out catalog selects as four desktop columns and fewer narrow columns.
final class _AdminAppointmentsFilterFields extends StatelessWidget {
  const _AdminAppointmentsFilterFields({
    required this.filter,
    required this.catalog,
  });

  final AdminAppointmentFilter filter;
  final ClinicCatalog catalog;

  Widget _field(double width, Widget child) {
    return SizedBox(width: width, child: child);
  }

  Widget _branchField(BuildContext context) {
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

  Widget _departmentField(BuildContext context) {
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

  Widget _staffField(BuildContext context) {
    return AppSelectField<String?>(
      label: LocaleKeys.admin_appointmentsPage_staff.translate(),
      hint: LocaleKeys.admin_appointmentsPage_allStaff.translate(),
      value: filter.staffId,
      highlightSelection: true,
      options: [
        AppSelectOption<String?>(
          value: null,
          label: LocaleKeys.admin_appointmentsPage_allStaff.translate(),
        ),
        for (final staff in filter.staffIn(catalog))
          AppSelectOption<String?>(value: staff.id, label: staff.fullName),
      ],
      onChanged: context.read<AdminAppointmentsCubit>().selectStaff,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = context.screenSize.select(
          mobile: AdminLayoutConstants.appointmentsFilterMobileColumns,
          tablet: AdminLayoutConstants.appointmentsFilterTabletColumns,
          desktop: AdminLayoutConstants.appointmentsFilterDesktopColumns,
        );
        final fieldWidth =
            (constraints.maxWidth - AppSizes.s12 * columns) / columns;
        return Wrap(
          spacing: AppSizes.s12,
          runSpacing: AppSizes.s12,
          children: [
            _field(fieldWidth, _AdminAppointmentDateRangeField(filter: filter)),
            _field(fieldWidth, _branchField(context)),
            _field(fieldWidth, _departmentField(context)),
            _field(fieldWidth, _staffField(context)),
          ],
        );
      },
    );
  }
}
