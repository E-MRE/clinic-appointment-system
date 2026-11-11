part of 'staff_requests_page.dart';

/// Switches between loading, failure, empty and the pending requests.
final class _StaffRequestsBody extends StatelessWidget {
  const _StaffRequestsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffAppointmentsCubit, StaffAppointmentsState>(
      builder: (context, state) {
        return _buildChild(state);
      },
    );
  }

  Widget _buildChild(StaffAppointmentsState state) {
    if (state is StaffAppointmentsFailure) {
      return _StaffRequestsFailure(message: state.errorCode.message);
    }

    if (state is StaffAppointmentsLoaded) {
      final requests = state.pendingRequests;
      if (requests.isEmpty) return const _StaffRequestsEmpty();
      return _StaffRequestsList(requests: requests);
    }

    return LoadingState(
      variant: LoadingStateVariant.skeletonList,
      label: LocaleKeys.staffRequests_loading.translate(),
    );
  }
}
