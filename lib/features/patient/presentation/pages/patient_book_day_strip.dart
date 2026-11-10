part of 'patient_book_page.dart';

/// Equal-width cells for the listed days of the week.
final class _PatientBookDayStrip extends StatelessWidget {
  const _PatientBookDayStrip({required this.days, required this.selectedDate});

  final List<StaffScheduleDay> days;
  final CalendarDate? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSizes.s8,
      children: [
        for (final day in days)
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
