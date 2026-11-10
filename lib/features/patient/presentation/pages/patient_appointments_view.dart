part of 'patient_appointments_page.dart';

/// Switches between loading, failure and the loaded appointments.
final class _PatientAppointmentsView extends StatelessWidget {
  const _PatientAppointmentsView({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final catalogState = context.watch<PatientCatalogCubit>().state;
    final appointmentsState = context.watch<PatientAppointmentsCubit>().state;

    return AppScaffold(child: _buildChild(appointmentsState, catalogState));
  }

  Widget _buildChild(
    PatientAppointmentsState appointmentsState,
    PatientCatalogState catalogState,
  ) {
    if (appointmentsState is PatientAppointmentsFailure) {
      return _PatientAppointmentsFailure(
        errorCode: appointmentsState.errorCode,
      );
    }

    if (catalogState is PatientCatalogFailure) {
      return const _PatientAppointmentsFailure(
        errorCode: AppointmentErrorCode.unavailable,
      );
    }

    if (catalogState is PatientCatalogLoaded &&
        appointmentsState is PatientAppointmentsLoaded) {
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

    return LoadingState(
      variant: LoadingStateVariant.skeletonList,
      label: LocaleKeys.patient_appointments_loading.translate(),
    );
  }
}
