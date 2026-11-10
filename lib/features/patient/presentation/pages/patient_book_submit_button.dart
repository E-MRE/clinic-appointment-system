part of 'patient_book_page.dart';

/// Requests the appointment once service, staff member and slot are chosen
/// and their schedule is loaded; shows progress while the request runs.
final class _PatientBookSubmitButton extends StatelessWidget {
  const _PatientBookSubmitButton({
    required this.selection,
    required this.patient,
    required this.isBusy,
  });

  final BookingSelection selection;
  final PatientAppointmentActor patient;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final scheduleState = context.watch<StaffWeekScheduleCubit>().state;
    final StaffWeekSchedule? schedule;
    if (scheduleState is StaffWeekScheduleLoaded &&
        selection.isComplete &&
        selection.isScheduledBy(scheduleState.schedule.request)) {
      schedule = scheduleState.schedule;
    } else {
      schedule = null;
    }
    final VoidCallback? onPressed;
    if (schedule == null || isBusy) {
      onPressed = null;
    } else {
      final availableSchedule = schedule;
      onPressed = () => _submit(context, availableSchedule);
    }
    return FilledButton(
      onPressed: onPressed,
      child: isBusy
          ? const _PatientBookSubmitProgress()
          : Text(LocaleKeys.patient_book_submit.translate()),
    );
  }

  void _submit(BuildContext context, StaffWeekSchedule schedule) {
    context.read<BookAppointmentCubit>().submit(
      selection: selection,
      schedule: schedule,
      patient: patient,
    );
  }
}
