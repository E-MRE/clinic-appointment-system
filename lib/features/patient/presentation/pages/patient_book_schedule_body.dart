part of 'patient_book_page.dart';

/// Shows the current schedule, its loading state or its failure state.
final class _PatientBookScheduleBody extends StatelessWidget {
  const _PatientBookScheduleBody({
    required this.state,
    required this.selection,
  });

  final StaffWeekScheduleState state;
  final BookingSelection selection;

  @override
  Widget build(BuildContext context) {
    final scheduleState = state;
    if (scheduleState is StaffWeekScheduleLoaded &&
        selection.isScheduledBy(scheduleState.schedule.request)) {
      return _PatientBookWeekSlots(
        schedule: scheduleState.schedule,
        selection: selection,
      );
    }

    if (scheduleState is StaffWeekScheduleFailure) {
      return const _PatientBookScheduleFailure();
    }

    return LoadingState(
      variant: LoadingStateVariant.centeredIndicator,
      label: LocaleKeys.patient_book_scheduleLoading.translate(),
    );
  }
}
