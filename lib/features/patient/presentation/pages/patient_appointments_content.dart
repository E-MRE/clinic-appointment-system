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
          child: _buildContent(context),
        ),
      ),
    );
  }

  /// Builds the page header and responsive appointment columns.
  Column _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s24,
      children: [
        PageHeader(
          title: LocaleKeys.patient_appointments_title.translate(),
          subtitle: overview.greeting(firstName),
        ),
        if (context.screenSize.isDesktop)
          _buildDesktopColumns()
        else ...[
          _buildPrimaryColumn(),
          _buildSecondaryColumn(),
        ],
      ],
    );
  }

  /// Builds both appointment columns side by side on desktop.
  Row _buildDesktopColumns() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.s24,
      children: [
        Expanded(
          flex: PatientLayoutConstants.appointmentsPrimaryFlex,
          child: _buildPrimaryColumn(),
        ),
        Expanded(
          flex: PatientLayoutConstants.appointmentsSecondaryFlex,
          child: _buildSecondaryColumn(),
        ),
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
