part of 'patient_book_page.dart';

/// A day's weekday, day number and free count, closed or full state.
final class _PatientBookDayCell extends StatelessWidget {
  const _PatientBookDayCell({required this.day, required this.isSelected});

  final StaffScheduleDay day;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final style = day.cellStyle(isSelected: isSelected);
    return _PatientBookChoiceCell(
      style: style,
      minHeight: AppSizes.bookingDayCellMinHeight,
      onTap: () => context.read<BookingSelectionCubit>().selectDate(day.date),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText.caption(day.weekdayLabel, tone: style.tone, maxLines: 1),
          AppText.sectionTitle(day.dayLabel, tone: style.tone, maxLines: 1),
          AppText.caption(
            day.statusLabel,
            tone: style.tone,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
