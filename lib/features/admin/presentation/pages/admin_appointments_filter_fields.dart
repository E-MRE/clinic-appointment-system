part of 'admin_appointments_page.dart';

/// Lays out catalog selects as four desktop columns and fewer narrow columns.
final class _AdminAppointmentsFilterFields extends StatelessWidget {
  const _AdminAppointmentsFilterFields({
    required this.filter,
    required this.catalog,
  });

  final AdminAppointmentFilter filter;
  final ClinicCatalog catalog;

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
            _field(
              fieldWidth,
              _AdminAppointmentsFilterBranchField(
                filter: filter,
                catalog: catalog,
              ),
            ),
            _field(
              fieldWidth,
              _AdminAppointmentsFilterDepartmentField(
                filter: filter,
                catalog: catalog,
              ),
            ),
            _field(
              fieldWidth,
              _AdminAppointmentsFilterStaffField(
                filter: filter,
                catalog: catalog,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _field(double width, Widget child) {
    return SizedBox(width: width, child: child);
  }
}
