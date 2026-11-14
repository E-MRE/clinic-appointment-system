part of 'patient_appointments_page.dart';

/// Appointment details with the patient's cancel action.
/// Owns its cancel request: closes with a confirmation on success and
/// shows the localized error in place on failure. If the appointment leaves
/// the observed list, keeps the entry that was current when the dialog opened.
final class _PatientAppointmentsDetailsDialog extends StatelessWidget {
  const _PatientAppointmentsDetailsDialog({
    required this.appointmentId,
    required this.initialEntry,
    required this.appointmentsCubit,
    required this.catalogCubit,
  });

  final String appointmentId;
  final PatientAppointmentEntry initialEntry;
  final PatientAppointmentsCubit appointmentsCubit;
  final ClinicCatalogCubit catalogCubit;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PatientAppointmentsCubit>.value(value: appointmentsCubit),
        BlocProvider<ClinicCatalogCubit>.value(value: catalogCubit),
      ],
      child: BlocProvider<PatientAppointmentCancelCubit>(
        create: (_) {
          return AppDependency.injector.get<PatientAppointmentCancelCubit>();
        },
        child:
            BlocListener<PatientAppointmentCancelCubit, AppointmentActionState>(
              listener: _onCancelState,
              child:
                  BlocBuilder<
                    PatientAppointmentsCubit,
                    PatientAppointmentsState
                  >(
                    builder: (context, appointmentsState) {
                      final catalogState = context
                          .watch<ClinicCatalogCubit>()
                          .state;
                      final entry = _currentEntry(
                        appointmentsState,
                        catalogState,
                      );

                      return AppFormDialog(
                        title: entry.serviceName,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          spacing: AppSizes.s16,
                          children: [
                            AppDefinitionRow(
                              label: LocaleKeys
                                  .patient_appointments_dialog_dateTime
                                  .translate(),
                              child: AppText.bodyStrong(
                                entry.longDateTimeLabel,
                              ),
                            ),
                            AppDefinitionRow(
                              label: LocaleKeys
                                  .patient_appointments_dialog_staff
                                  .translate(),
                              child: AppText.bodyStrong(entry.staffName),
                            ),
                            AppDefinitionRow(
                              label: LocaleKeys
                                  .patient_appointments_dialog_location
                                  .translate(),
                              child: AppText.bodyStrong(entry.location),
                            ),
                            AppDefinitionRow(
                              label: LocaleKeys.patient_appointments_dialog_fee
                                  .translate(),
                              child: AppText.bodyStrong(entry.fee),
                            ),
                            AppDefinitionRow(
                              label: LocaleKeys
                                  .patient_appointments_dialog_status
                                  .translate(),
                              child: AppointmentStatusBadge(
                                status: entry.appointment.status,
                              ),
                            ),
                            if (entry.cancellationNote != null)
                              AppDefinitionRow(
                                label: LocaleKeys
                                    .patient_appointments_dialog_note
                                    .translate(),
                                child: AppText.bodyStrong(
                                  entry.cancellationNote ?? '',
                                ),
                              ),
                            const _PatientAppointmentsCancelError(),
                            _PatientAppointmentsDialogActions(entry: entry),
                          ],
                        ),
                      );
                    },
                  ),
            ),
      ),
    );
  }

  PatientAppointmentEntry _currentEntry(
    PatientAppointmentsState appointmentsState,
    ClinicCatalogState catalogState,
  ) {
    if (appointmentsState is PatientAppointmentsLoaded) {
      if (catalogState is ClinicCatalogLoaded) {
        final overview = PatientAppointmentsOverview(
          appointments: appointmentsState.appointments,
          catalog: catalogState.catalog,
          now: AppDependency.injector.get<Clock>().now(),
          patient: PatientAppointmentActor(
            id: initialEntry.appointment.patientId,
          ),
        );
        for (final entry in overview.all) {
          if (entry.appointment.id == appointmentId) return entry;
        }
      }
    }
    return initialEntry;
  }

  /// Closes the dialog and confirms a successful cancellation.
  void _onCancelState(BuildContext context, AppointmentActionState state) {
    if (state is! AppointmentActionSuccess) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text(LocaleKeys.patient_appointments_cancelled.translate()),
      ),
    );
  }
}
