part of 'patient_appointments_page.dart';

/// Switches between loading, failure and loaded appointment content.
final class _PatientAppointmentsViewChild extends StatelessWidget {
  const _PatientAppointmentsViewChild({
    required this.user,
    required this.appointmentsState,
    required this.catalogState,
  });

  final User user;
  final PatientAppointmentsState appointmentsState;
  final ClinicCatalogState catalogState;

  @override
  Widget build(BuildContext context) {
    final currentAppointmentsState = appointmentsState;
    if (currentAppointmentsState is PatientAppointmentsFailure) {
      return _failure(currentAppointmentsState.errorCode);
    }

    if (catalogState is ClinicCatalogFailure) {
      return _failure(AppointmentErrorCode.unavailable);
    }

    if (catalogState is ClinicCatalogLoaded &&
        currentAppointmentsState is PatientAppointmentsLoaded) {
      return _loadedContent(currentAppointmentsState);
    }

    return LoadingState(
      variant: LoadingStateVariant.skeletonList,
      label: LocaleKeys.patient_appointments_loading.translate(),
    );
  }

  Widget _failure(AppointmentErrorCode errorCode) {
    return _PatientAppointmentsFailure(errorCode: errorCode);
  }

  Widget _loadedContent(PatientAppointmentsLoaded appointmentsState) {
    return _PatientAppointmentsContent(
      firstName: user.firstName,
      overview: appointmentsState.overview,
      bookableDepartments: appointmentsState.bookableDepartments,
    );
  }
}
