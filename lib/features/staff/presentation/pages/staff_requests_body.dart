part of 'staff_requests_page.dart';

/// Switches between loading, failure, empty and the pending requests.
final class _StaffRequestsBody extends StatelessWidget {
  const _StaffRequestsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffRequestsCubit, StaffRequestsState>(
      builder: (context, state) {
        return _buildChild(state);
      },
    );
  }

  Widget _buildChild(StaffRequestsState state) {
    if (state is StaffRequestsFailure) {
      return _StaffRequestsFailure(message: state.errorCode.message);
    }

    if (state is StaffRequestsLoaded) {
      if (state.requests.isEmpty) return const _StaffRequestsEmpty();
      return _StaffRequestsList(requests: state.requests);
    }

    return LoadingState(
      variant: LoadingStateVariant.skeletonList,
      label: LocaleKeys.staffRequests_loading.translate(),
    );
  }
}
