part of 'staff_requests_page.dart';

/// Switches between loading, failure, empty and the requests layout.
final class _StaffRequestsBody extends StatelessWidget {
  const _StaffRequestsBody();

  @override
  Widget build(BuildContext context) {
    final appointmentsState = context.watch<StaffAppointmentsCubit>().state;
    final workspaceState = context.watch<StaffWorkspaceCubit>().state;

    if (appointmentsState is StaffAppointmentsFailure) {
      return _StaffRequestsFailure(
        message: appointmentsState.errorCode.message,
      );
    }
    if (workspaceState is StaffWorkspaceFailure) {
      return _StaffRequestsFailure(
        message: LocaleKeys.staffRequests_failureTitle.translate(),
      );
    }

    if (appointmentsState is! StaffAppointmentsLoaded ||
        workspaceState is! StaffWorkspaceLoaded) {
      return LoadingState(
        variant: LoadingStateVariant.skeletonList,
        label: LocaleKeys.staffRequests_loading.translate(),
      );
    }

    final requests = appointmentsState.pendingRequests;
    if (requests.isEmpty) {
      return const _StaffRequestsEmpty();
    }

    final selectionState = context.watch<StaffRequestSelectionCubit>().state;
    final sortedRequests = selectionState.sort.sort(requests);
    final selectedId = selectionState.selectedRequestId;

    if (context.screenSize.isDesktop) {
      return _StaffRequestsDesktopLayout(
        requests: sortedRequests,
        selectedId: selectedId,
      );
    }

    return _StaffRequestsNarrowLayout(
      requests: sortedRequests,
      selectedId: selectedId,
    );
  }
}
