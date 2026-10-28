part of 'working_hours_editor.dart';

/// Weekday label and open switch.
final class _WorkingHoursEditorDayHeader extends StatelessWidget {
  const _WorkingHoursEditorDayHeader({required this.day, required this.isOpen});

  final Weekday day;
  final bool isOpen;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: AppText.bodyStrong(day.label)),
        Switch(
          value: isOpen,
          onChanged: (_) =>
              context.read<WorkingHoursEditorCubit>().toggleDay(day),
        ),
      ],
    );
  }
}
