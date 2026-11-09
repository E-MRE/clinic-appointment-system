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
    final schedule = switch (scheduleState) {
      StaffWeekScheduleLoaded(:final schedule)
          when selection.isComplete &&
              selection.isScheduledBy(schedule.request) =>
        schedule,
      _ => null,
    };
    return FilledButton(
      onPressed: schedule == null || isBusy
          ? null
          : () => _submit(context, schedule),
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
