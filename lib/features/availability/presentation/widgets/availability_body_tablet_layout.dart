part of 'availability_body.dart';

/// Tablet timeline and dated extras with a dialog editor in the header.
final class _AvailabilityTabletLayout extends StatelessWidget {
  const _AvailabilityTabletLayout();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AvailabilityTimeline(),
          EmptySize.s16Height(),
          _AvailabilityTimelineFootnote(),
          EmptySize.s24Height(),
          AppSurface(
            padding: AppSurfacePadding.spacious,
            radius: AppSurfaceRadius.panel,
            child: _AvailabilityOneOffSection(),
          ),
        ],
      ),
    );
  }
}
