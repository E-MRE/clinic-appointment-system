part of 'working_hours_editor.dart';

/// Removes one opening range.
final class _WorkingHoursEditorRangeRemove extends StatelessWidget {
  const _WorkingHoursEditorRangeRemove({
    required this.day,
    required this.index,
  });

  final Weekday day;
  final int index;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: LocaleKeys.institution_rangeRemove.tr(),
      onPressed: () =>
          context.read<WorkingHoursEditorCubit>().removeRange(day, index),
      icon: const Icon(Icons.remove_circle_outline),
    );
  }
}
