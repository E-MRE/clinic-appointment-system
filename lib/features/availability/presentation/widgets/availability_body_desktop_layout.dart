part of 'availability_body.dart';

/// Persistent editor beside independently scrollable weekly and dated cards.
final class _AvailabilityDesktopLayout extends StatelessWidget {
  const _AvailabilityDesktopLayout();

  @override
  Widget build(BuildContext context) {
    return AppSidePanelLayout(
      showsPanel: true,
      panel: const AppSidePanel(child: _AvailabilityWindowPanel()),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSizes.s24,
          children: [
            _buildWeeklyCard(),
            const AppSurface(
              padding: AppSurfacePadding.spacious,
              radius: AppSurfaceRadius.panel,
              child: _AvailabilityOneOffSection(),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the weekly timeline surface and its heading.
  Widget _buildWeeklyCard() {
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
