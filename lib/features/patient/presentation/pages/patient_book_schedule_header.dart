part of 'patient_book_page.dart';

/// Step title with the previous and next week buttons around the week.
final class _PatientBookScheduleHeader extends StatelessWidget {
  const _PatientBookScheduleHeader({
    required this.selection,
    required this.catalog,
  });

  final BookingSelection selection;
  final PatientCatalog catalog;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BookingSelectionCubit>();
    return Row(
      spacing: AppSizes.s8,
      children: [
        Expanded(
          child: _PatientBookSectionTitle(
            title: LocaleKeys.patient_book_scheduleTitle.translate(),
          ),
        ),
        _PatientBookWeekButton(
          icon: Icons.chevron_left,
          tooltip: LocaleKeys.patient_book_previousWeek.translate(),
          onPressed: selection.canShowPreviousWeek
              ? cubit.showPreviousWeek
              : null,
        ),
        AppText.bodyStrong(selection.weekLabel(catalog)),
        _PatientBookWeekButton(
          icon: Icons.chevron_right,
          tooltip: LocaleKeys.patient_book_nextWeek.translate(),
          onPressed: cubit.showNextWeek,
        ),
      ],
    );
  }
}
