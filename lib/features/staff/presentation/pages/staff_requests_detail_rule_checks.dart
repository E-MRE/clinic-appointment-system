part of 'staff_requests_page.dart';

/// Live rule check rows for the pending appointment request.
final class _StaffRequestDetailRuleChecks extends StatelessWidget {
  const _StaffRequestDetailRuleChecks({
    required this.request,
    required this.workspace,
    required this.service,
    required this.appointments,
  });

  final Appointment request;
  final StaffWorkspace workspace;
  final MedicalService service;
  final List<Appointment> appointments;

  @override
  Widget build(BuildContext context) {
    final clock = AppDependency.injector.get<Clock>();
    final checks = const StaffRuleCheckFactory().create(
      request: request,
      staff: workspace.staff,
      service: service,
      availability: workspace.availability,
      branchHours: workspace.branch.workingHours,
      appointments: appointments,
      now: clock.now(),
    );

    final colors = context.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: AppSizes.s12,
      children: [
        AppText.sectionTitle(
          LocaleKeys.staffRequests_detail_rulesSection.translate(),
        ),
        for (final item in checks)
          Row(
            spacing: AppSizes.s8,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                item.icon,
                size: AppSizes.s20,
                color: item.passed ? colors.primary : colors.error,
              ),
              Expanded(child: AppText.body(item.message)),
            ],
          ),
      ],
    );
  }
}
