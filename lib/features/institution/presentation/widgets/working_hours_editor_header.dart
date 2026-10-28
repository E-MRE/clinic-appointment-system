part of 'working_hours_editor.dart';

/// Heading and copy-to-weekdays action.
final class _WorkingHoursEditorHeader extends StatelessWidget {
  const _WorkingHoursEditorHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppText.sectionTitle(LocaleKeys.institution_workingHours.tr()),
        ),
        TextButton(
          onPressed: () => context
              .read<WorkingHoursEditorCubit>()
              .copyToWeekdays(Weekday.monday),
          child: AppText.label(LocaleKeys.institution_copyToWeekdays.tr()),
        ),
      ],
    );
  }
}
