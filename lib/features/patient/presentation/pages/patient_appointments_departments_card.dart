part of 'patient_appointments_page.dart';

/// Departments offering bookable services; each opens the booking page.
final class _PatientAppointmentsDepartmentsCard extends StatelessWidget {
  const _PatientAppointmentsDepartmentsCard({required this.departments});

  final List<PatientDepartmentSummary> departments;

  @override
  Widget build(BuildContext context) {
    return AppSurface(
      padding: AppSurfacePadding.comfortable,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s12,
        children: [
          Semantics(
            header: true,
            child: AppText.cardTitle(
              LocaleKeys.patient_appointments_departmentsTitle.translate(),
            ),
          ),
          for (final summary in departments)
            _PatientAppointmentsDepartmentRow(summary: summary),
        ],
      ),
    );
  }
}
