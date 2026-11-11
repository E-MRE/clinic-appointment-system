part of 'staff_requests_page.dart';

/// Top bar with the title, pending requests count / age subtitle and sort toggle.
final class _StaffRequestsHeader extends StatelessWidget {
  const _StaffRequestsHeader();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StaffAppointmentsCubit>().state;
    final String? subtitle;
    if (state is StaffAppointmentsLoaded) {
      final clock = AppDependency.injector.get<Clock>();
      subtitle = state.pendingRequests.headerSubtitle(clock);
    } else {
      subtitle = null;
    }

    final isDesktop = context.screenSize.isDesktop;

    if (isDesktop) {
      return PageHeader(
        title: LocaleKeys.staffRequests_headerTitle.translate(),
        subtitle: subtitle,
        actions: const _StaffRequestsSortToggle(),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PageHeader(
          title: LocaleKeys.staffRequests_headerTitle.translate(),
          subtitle: subtitle,
        ),
        const EmptySize.s8Height(),
        const _StaffRequestsSortToggle(),
      ],
    );
  }
}
