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
              child: _PatientAppointmentsDetailsContent(
                appointmentId: appointmentId,
                initialEntry: initialEntry,
              ),
            ),
      ),
    );
  }

  /// Closes the dialog and confirms a successful cancellation.
  void _onCancelState(BuildContext context, AppointmentActionState state) {
    if (state is! AppointmentActionSuccess) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        content: AppText.body(
          LocaleKeys.patient_appointments_cancelled.translate(),
          tone: TextTone.onInverse,
        ),
      ),
    );
  }
}
