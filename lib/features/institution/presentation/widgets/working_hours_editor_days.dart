part of 'working_hours_editor.dart';

/// Rebuilds the seven day rows when the editor changes.
final class _WorkingHoursEditorDays extends StatelessWidget {
  const _WorkingHoursEditorDays();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkingHoursEditorCubit, WorkingHoursEditorState>(
      builder: (context, state) => Column(
        children: [
          for (final day in Weekday.values) _WorkingHoursEditorDay(day: day),
        ],
      ),
    );
  }
}
