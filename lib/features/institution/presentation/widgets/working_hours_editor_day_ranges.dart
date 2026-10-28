part of 'working_hours_editor.dart';

/// Range controls for one open weekday.
final class _WorkingHoursEditorDayRanges extends StatelessWidget {
  const _WorkingHoursEditorDayRanges({
    required this.day,
    required this.rangeCount,
  });

  final Weekday day;
  final int rangeCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (int index = 0; index < rangeCount; index++)
          _WorkingHoursEditorRange(day: day, index: index),
        TextButton.icon(
          onPressed: () =>
              context.read<WorkingHoursEditorCubit>().addRange(day),
          icon: const Icon(Icons.add),
          label: AppText.label(LocaleKeys.institution_rangeAdd.tr()),
        ),
      ],
    );
  }
}
