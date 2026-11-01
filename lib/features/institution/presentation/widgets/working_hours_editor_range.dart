part of 'working_hours_editor.dart';

/// Start, end and remove controls for one opening range.
final class _WorkingHoursEditorRange extends StatelessWidget {
  const _WorkingHoursEditorRange({required this.day, required this.index});

  final Weekday day;
  final int index;

  @override
  Widget build(BuildContext context) {
    final range = context
        .watch<WorkingHoursEditorCubit>()
        .state
        .day(day)
        .ranges[index];
    return Row(
      children: [
        TextButton(
          onPressed: () => _pick(context, start: true),
          child: AppText.label(range.start.toString()),
        ),
        const AppText.body('–'),
        TextButton(
          onPressed: () => _pick(context, start: false),
          child: AppText.label(range.end.toString()),
        ),
        _WorkingHoursEditorRangeRemove(day: day, index: index),
      ],
    );
  }

  Future<void> _pick(BuildContext context, {required bool start}) async {
    final editor = context.read<WorkingHoursEditorCubit>();
    final draft = editor.state.day(day).ranges[index];
    final original = start ? draft.start : draft.end;
    final chosen = await context.pickClockTime(initial: original);
    if (chosen == null || context.mounted == false) return;
    editor.updateRange(
      day,
      index,
      start ? chosen : draft.start,
      start ? draft.end : chosen,
    );
  }
}
