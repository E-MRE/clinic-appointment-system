part of 'patient_book_page.dart';

/// The day strip, the chosen day's slot groups and the footnote.
final class _PatientBookWeekSlots extends StatelessWidget {
  const _PatientBookWeekSlots({
    required this.schedule,
    required this.selection,
  });

  final StaffWeekSchedule schedule;
  final BookingSelection selection;

  @override
  Widget build(BuildContext context) {
    final date = selection.date;
    final day = selection.scheduleDay;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s20,
      children: [
        _buildDayStrip(date),
        if (day == null)
          AppText.body(
            LocaleKeys.patient_book_noFreeDay.translate(),
            tone: TextTone.muted,
          )
        else
          for (final group in day.groups)
            _PatientBookSlotGroup(group: group, selectedSlot: selection.slot),
        AppText.caption(selection.footnote, tone: TextTone.muted),
      ],
    );
  }

  /// Builds equal-width cells for each day in the schedule.
  Row _buildDayStrip(CalendarDate? selectedDate) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.s8,
      children: [
        for (final day in schedule.days)
          Expanded(
            child: _PatientBookDayCell(
              day: day,
              isSelected: day.date == selectedDate,
            ),
          ),
      ],
    );
  }
}
