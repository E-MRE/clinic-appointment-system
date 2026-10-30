part of 'working_hours_section.dart';

/// Heading and edit action for read-only working hours.
final class _WorkingHoursSectionHeader extends StatelessWidget {
  const _WorkingHoursSectionHeader({required this.onEdit});

  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppText.sectionTitle(LocaleKeys.institution_workingHours.tr()),
        ),
        TextButton(
          onPressed: onEdit,
          child: AppText.label(LocaleKeys.institution_editWorkingHours.tr()),
        ),
      ],
    );
  }
}
