part of 'staff_requests_page.dart';

/// Top bar with the title, pending requests count / age subtitle and sort toggle.
final class _StaffRequestsHeader extends StatelessWidget {
  const _StaffRequestsHeader();

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StaffAppointmentsCubit>().state;
    final String? subtitle = _getSubtitle(state);

    if (context.screenSize.isDesktop) {
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

  String? _getSubtitle(StaffAppointmentsState state) {
    if (state is StaffAppointmentsLoaded) {
      final clock = AppDependency.injector.get<Clock>();
      return state.pendingRequests.headerSubtitle(clock);
    }

    return null;
  }
}
