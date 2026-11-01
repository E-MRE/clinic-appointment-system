part of 'availability_body.dart';

/// Persistent editor beside independently scrollable weekly and dated cards.
final class _AvailabilityDesktopLayout extends StatelessWidget {
  const _AvailabilityDesktopLayout();

  @override
  Widget build(BuildContext context) {
    return const AppSidePanelLayout(
      showsPanel: true,
      panel: AppSidePanel(child: _AvailabilityWindowPanel()),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: AppSizes.s24,
          children: [
            _AvailabilityWeeklyCard(),
            AppSurface(
              padding: AppSurfacePadding.spacious,
              radius: AppSurfaceRadius.panel,
              child: _AvailabilityOneOffSection(),
            ),
          ],
        ),
      ),
    );
  }
}
