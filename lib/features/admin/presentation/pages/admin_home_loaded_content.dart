part of 'admin_home_page.dart';

/// Composes the KPI, breakdown and pending request sections.
final class _AdminHomeLoadedContent extends StatelessWidget {
  const _AdminHomeLoadedContent({
    required this.clock,
    required this.summary,
    required this.catalog,
    required this.actor,
  });

  final Clock clock;
  final AdminDashboardSummary summary;
  final ClinicCatalog catalog;
  final AdminAppointmentActor actor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s24,
      children: [
        _AdminHomeMetricCards(clock: clock, summary: summary),
        _AdminHomeBreakdownCards(summary: summary),
        _AdminHomePendingTable(
          clock: clock,
          summary: summary,
          catalog: catalog,
          actor: actor,
        ),
      ],
    );
  }
}
