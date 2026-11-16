part of 'patient_appointments_page.dart';

/// Header and the two content columns; one column below desktop width.
final class _PatientAppointmentsContent extends StatelessWidget {
  const _PatientAppointmentsContent({
    required this.firstName,
    required this.overview,
    required this.bookableDepartments,
  });

  final String firstName;
  final PatientAppointmentsOverview overview;
  final List<PatientDepartmentSummary> bookableDepartments;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSizes.patientContentMaxWidth,
          ),
          child: _PatientAppointmentsContentBody(
            firstName: firstName,
            overview: overview,
            bookableDepartments: bookableDepartments,
          ),
        ),
      ),
    );
  }
}
