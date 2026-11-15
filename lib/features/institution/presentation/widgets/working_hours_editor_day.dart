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
        _buildHeader(context, draft.isOpen),
        if (draft.isOpen)
          _buildRanges(context, draft.ranges.length)
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

  /// Builds the weekday label and open switch.
  Widget _buildHeader(BuildContext context, bool isOpen) {
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

  /// Builds range controls for one open weekday.
  Widget _buildRanges(BuildContext context, int rangeCount) {
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
