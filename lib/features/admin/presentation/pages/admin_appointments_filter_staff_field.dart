part of 'admin_appointments_page.dart';

/// Selects a staff member for the appointment filters.
final class _AdminAppointmentsFilterStaffField extends StatelessWidget {
  /// Creates a staff field from the current catalog and filter.
  const _AdminAppointmentsFilterStaffField({
    required this.filter,
    required this.catalog,
  });

  final AdminAppointmentFilter filter;
  final ClinicCatalog catalog;

  @override
  Widget build(BuildContext context) {
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
}
