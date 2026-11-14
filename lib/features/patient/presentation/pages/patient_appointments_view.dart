part of 'patient_appointments_page.dart';

/// Switches between loading, failure and the loaded appointments.
final class _PatientAppointmentsView extends StatelessWidget {
  const _PatientAppointmentsView({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final catalogState = context.watch<ClinicCatalogCubit>().state;
    final appointmentsState = context.watch<PatientAppointmentsCubit>().state;

    return AppScaffold(child: _buildChild(appointmentsState, catalogState));
  }

  Widget _buildChild(
    PatientAppointmentsState appointmentsState,
    ClinicCatalogState catalogState,
  ) {
    if (appointmentsState is PatientAppointmentsFailure) {
      return _failure(appointmentsState.errorCode);
    }

    if (catalogState is ClinicCatalogFailure) {
      return _failure(AppointmentErrorCode.unavailable);
    }

    if (catalogState is ClinicCatalogLoaded &&
        appointmentsState is PatientAppointmentsLoaded) {
      return _loadedContent(appointmentsState, catalogState);
    }

    return LoadingState(
      variant: LoadingStateVariant.skeletonList,
      label: LocaleKeys.patient_appointments_loading.translate(),
    );
  }

  Widget _failure(AppointmentErrorCode errorCode) {
    return _PatientAppointmentsFailure(errorCode: errorCode);
  }

  Widget _loadedContent(
    PatientAppointmentsLoaded appointmentsState,
    ClinicCatalogLoaded catalogState,
  ) {
    return _PatientAppointmentsContent(
      firstName: user.firstName,
      overview: PatientAppointmentsOverview(
        appointments: appointmentsState.appointments,
        catalog: catalogState.catalog,
        now: AppDependency.injector.get<Clock>().now(),
        patient: PatientAppointmentActor(id: user.id),
      ),
    );
  }
}
