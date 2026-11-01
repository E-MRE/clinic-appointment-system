part of 'availability_body.dart';

/// The weekly card heading and branch axis summary.
final class _AvailabilityWeeklyHeading extends StatelessWidget {
  const _AvailabilityWeeklyHeading();

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: AppSizes.s12,
      children: [
        Expanded(
          child: Semantics(
            header: true,
            child: AppText.cardTitle(
              LocaleKeys.availability_weeklyTitle.translate(),
            ),
          ),
        ),
        const _AvailabilityBranchCaption(),
      ],
    );
  }
}
