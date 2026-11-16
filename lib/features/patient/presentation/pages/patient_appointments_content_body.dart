part of 'patient_appointments_page.dart';

/// Builds the appointments header and responsive content columns.
final class _PatientAppointmentsContentBody extends StatelessWidget {
  const _PatientAppointmentsContentBody({
    required this.firstName,
    required this.overview,
    required this.bookableDepartments,
  });

  final String firstName;
  final PatientAppointmentsOverview overview;
  final List<PatientDepartmentSummary> bookableDepartments;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s24,
      children: [
        PageHeader(
          title: LocaleKeys.patient_appointments_title.translate(),
          subtitle: overview.greeting(firstName),
        ),
        if (context.screenSize.isDesktop)
          _PatientAppointmentsContentDesktopColumns(
            primaryColumn: _buildPrimaryColumn(),
            secondaryColumn: _buildSecondaryColumn(),
          )
        else ...[
          _buildPrimaryColumn(),
          _buildSecondaryColumn(),
        ],
      ],
    );
  }

  /// Builds the next appointment and the appointments table.
  Column _buildPrimaryColumn() {
    final next = overview.next;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s24,
      children: [
        if (next != null) _PatientAppointmentsNextCard(entry: next),
        _PatientAppointmentsListCard(overview: overview),
      ],
    );
  }

  /// Builds preparation notes and bookable departments when present.
  Column _buildSecondaryColumn() {
    final notes = overview.preparationNotes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s16,
      children: [
        if (notes.isNotEmpty) _PatientAppointmentsNotesCard(notes: notes),
        if (bookableDepartments.isNotEmpty)
          _PatientAppointmentsDepartmentsCard(departments: bookableDepartments),
      ],
    );
  }
}
