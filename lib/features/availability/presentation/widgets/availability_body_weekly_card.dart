part of 'availability_body.dart';

/// Weekly timeline card with the branch name and common axis caption.
final class _AvailabilityWeeklyCard extends StatelessWidget {
  const _AvailabilityWeeklyCard();

  @override
  Widget build(BuildContext context) {
    return const AppSurface(
      radius: AppSurfaceRadius.panel,
      padding: AppSurfacePadding.spacious,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s16,
        children: [_AvailabilityWeeklyHeading(), _AvailabilityTimeline()],
      ),
    );
  }
}
