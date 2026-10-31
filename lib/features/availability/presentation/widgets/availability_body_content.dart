part of 'availability_body.dart';

/// Resolves observation states before selecting the device-specific layout.
final class _AvailabilityBodyContent extends StatelessWidget {
  const _AvailabilityBodyContent();

  @override
  Widget build(BuildContext context) {
    final availability = context.watch<StaffAvailabilityCubit>().state;
    final branch = context.watch<AvailabilityBranchCubit>().state;
    if (availability is WatchLoading || branch is WatchLoading) {
      return LoadingState(
        variant: LoadingStateVariant.skeletonList,
        label: LocaleKeys.availability_loading.translate(),
      );
    }
    if (availability case WatchFailure(:final code)) {
      return _AvailabilityFailure(message: code.message());
    }
    if (branch case WatchFailure(:final code)) {
      return _AvailabilityFailure(message: code.message);
    }
    return context.screenSize.select(
      mobile: const _AvailabilityMobileLayout(),
      tablet: const _AvailabilityTabletLayout(),
      desktop: const _AvailabilityDesktopViewport(),
    );
  }
}
