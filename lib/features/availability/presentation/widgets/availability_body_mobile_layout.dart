part of 'availability_body.dart';

/// Scrollable weekly rows and dated extras used by all breakpoints in stage 6a.
final class _AvailabilityMobileLayout extends StatelessWidget {
  const _AvailabilityMobileLayout();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _AvailabilityBranchBanner(),
          const EmptySize.s16Height(),
          for (final day in Weekday.values) _AvailabilityDayRow(day: day),
          const EmptySize.s24Height(),
          const _AvailabilityOneOffSection(),
        ],
      ),
    );
  }
}
