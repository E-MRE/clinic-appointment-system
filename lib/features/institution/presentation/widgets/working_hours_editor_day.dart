part of 'working_hours_editor.dart';

/// Open switch, ranges and error for a weekday.
final class _WorkingHoursEditorDay extends StatelessWidget {
  const _WorkingHoursEditorDay({required this.day});

  final Weekday day;

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<WorkingHoursEditorCubit>().state.day(day);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WorkingHoursEditorDayHeader(day: day, isOpen: draft.isOpen),
        if (draft.isOpen)
          _WorkingHoursEditorDayRanges(
            day: day,
            rangeCount: draft.ranges.length,
          )
        else
          AppText.caption(
            LocaleKeys.institution_closed.tr(),
            tone: TextTone.muted,
          ),
        if (draft.error case final error?)
          AppText.caption(error.message, tone: TextTone.error),
        const EmptySize.s8Height(),
      ],
    );
  }
}
