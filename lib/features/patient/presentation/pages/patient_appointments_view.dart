part of 'patient_appointments_page.dart';

/// Switches between loading, failure and the loaded appointments.
final class _PatientAppointmentsView extends StatelessWidget {
  const _PatientAppointmentsView({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    final catalogState = context.watch<PatientCatalogCubit>().state;
    final appointmentsState = context.watch<PatientAppointmentsCubit>().state;
    return AppScaffold(
      child: switch ((catalogState, appointmentsState)) {
        (_, PatientAppointmentsFailure(:final errorCode)) =>
          _PatientAppointmentsFailure(errorCode: errorCode),
        (PatientCatalogFailure(), _) => const _PatientAppointmentsFailure(
          errorCode: AppointmentErrorCode.unavailable,
        ),
        (
          PatientCatalogLoaded(:final catalog),
          PatientAppointmentsLoaded(:final appointments),
        ) =>
          _PatientAppointmentsContent(
            firstName: user.firstName,
            overview: PatientAppointmentsOverview(
              appointments: appointments,
              catalog: catalog,
              now: AppDependency.injector.get<Clock>().now(),
              patient: PatientAppointmentActor(id: user.id),
            ),
          ),
        _ => LoadingState(
          variant: LoadingStateVariant.skeletonList,
          label: LocaleKeys.patient_appointments_loading.translate(),
        ),
      },
    );
  }
}
