part of 'patient_appointments_page.dart';

/// Switches between loading, failure and the loaded appointments.
final class _PatientAppointmentsView extends StatelessWidget {
  const _PatientAppointmentsView({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final catalogState = context.watch<ClinicCatalogCubit>().state;
    final appointmentsState = context.watch<PatientAppointmentsCubit>().state;

    return AppScaffold(
      child: _PatientAppointmentsViewChild(
        user: user,
        appointmentsState: appointmentsState,
        catalogState: catalogState,
      ),
    );
  }
}
