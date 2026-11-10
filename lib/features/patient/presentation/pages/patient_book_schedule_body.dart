part of 'patient_book_page.dart';

/// The chosen staff member's week, or a hint, progress or failure.
final class _PatientBookScheduleBody extends StatelessWidget {
  const _PatientBookScheduleBody({required this.selection});

  final BookingSelection selection;

  @override
  Widget build(BuildContext context) {
    if (selection.staff == null) {
      return AppText.body(
        LocaleKeys.patient_book_scheduleHint.translate(),
        tone: TextTone.muted,
      );
    }
    return BlocBuilder<StaffWeekScheduleCubit, StaffWeekScheduleState>(
      builder: (context, state) {
        return _buildChild(state);
      },
    );
  }

  Widget _buildChild(StaffWeekScheduleState state) {
    if (state is StaffWeekScheduleLoaded &&
        selection.isScheduledBy(state.schedule.request)) {
      return _PatientBookWeekSlots(
        schedule: state.schedule,
        selection: selection,
      );
    }

    if (state is StaffWeekScheduleFailure) {
      return const _PatientBookScheduleFailure();
    }

    return LoadingState(
      variant: LoadingStateVariant.centeredIndicator,
      label: LocaleKeys.patient_book_scheduleLoading.translate(),
    );
  }
}
