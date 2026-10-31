part of 'availability_body.dart';

/// A daily total, track and optional desktop editor action.
final class _AvailabilityTimelineRow extends StatelessWidget {
  const _AvailabilityTimelineRow({required this.day, required this.timeline});
  final Weekday day;
  final AvailabilityTimeline timeline;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.screenSize.isDesktop
          ? const AppPadding.verticalMd()
          : const AppPadding.none(),
      decoration: BoxDecoration(
        border: context.screenSize.isDesktop
            ? Border(
                top: BorderSide(
                  color: context.colorScheme.outlineVariant,
                  width: AppSizes.borderThin,
                ),
              )
            : null,
      ),
      child: Row(
        spacing: AppSizes.s16,
        children: [
          _AvailabilityTimelineDayLabel(day: day),
          Expanded(
            child: _AvailabilityTimelineTrack(day: day, timeline: timeline),
          ),
          if (context.screenSize.isDesktop)
            _AvailabilityTimelineEditButton(day: day),
        ],
      ),
    );
  }
}
