part of 'staff_requests_page.dart';

/// Switches between loading, failure, empty and the pending requests.
final class _StaffRequestsBody extends StatelessWidget {
  const _StaffRequestsBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StaffRequestsCubit, StaffRequestsState>(
      builder: (context, state) {
        return switch (state) {
          StaffRequestsLoading() => LoadingState(
            variant: LoadingStateVariant.skeletonList,
            label: LocaleKeys.staffRequests_loading.translate(),
          ),
          StaffRequestsFailure(:final errorCode) => _StaffRequestsFailure(
            message: errorCode.message,
          ),
          StaffRequestsLoaded(:final requests) when requests.isEmpty =>
            const _StaffRequestsEmpty(),
          StaffRequestsLoaded(:final requests) => _StaffRequestsList(
            requests: requests,
          ),
        };
      },
    );
  }
}
