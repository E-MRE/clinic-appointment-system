part of 'patient_appointments_page.dart';

/// Preparation notes and bookable departments; empty panels are hidden.
final class _PatientAppointmentsSecondaryColumn extends StatelessWidget {
  const _PatientAppointmentsSecondaryColumn({
    required this.overview,
    required this.departments,
  });

  final PatientAppointmentsOverview overview;
  final List<PatientDepartmentSummary> departments;

  @override
  Widget build(BuildContext context) {
    final notes = overview.preparationNotes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s16,
      children: [
        if (notes.isNotEmpty) _PatientAppointmentsNotesCard(notes: notes),
        if (departments.isNotEmpty)
          _PatientAppointmentsDepartmentsCard(departments: departments),
      ],
    );
  }
}
