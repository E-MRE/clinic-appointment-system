part of 'patient_book_page.dart';

/// Requests the appointment once service, staff member and slot are chosen
/// and their schedule is loaded; shows progress while the request runs.
final class _PatientBookSubmitButton extends StatelessWidget {
  const _PatientBookSubmitButton({
    required this.selection,
    required this.patient,
    required this.patientName,
    required this.isBusy,
  });

  final BookingSelection selection;
  final PatientAppointmentActor patient;
  final String patientName;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StaffWeekScheduleCubit>().state;
    final schedule = _scheduleFor(state);

    return FilledButton(
      onPressed: schedule == null || isBusy
          ? null
          : () => _submit(context, schedule),
      child: isBusy
          ? const _PatientBookSubmitProgress()
          : Text(LocaleKeys.patient_book_submit.translate()),
    );
  }

  /// The loaded schedule when it belongs to the complete current selection.
  StaffWeekSchedule? _scheduleFor(StaffWeekScheduleState state) {
    if (state is! StaffWeekScheduleLoaded || !selection.isComplete) {
      return null;
    }
    final schedule = state.schedule;
    return selection.isScheduledBy(schedule.request) ? schedule : null;
  }

  void _submit(BuildContext context, StaffWeekSchedule schedule) {
    context.read<BookAppointmentCubit>().submit(
      selection: selection,
      schedule: schedule,
      patient: patient,
      patientName: patientName,
    );
  }
}
