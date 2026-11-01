part of 'availability_body.dart';

/// Informs staff of the branch hours constraining their availability.
final class _AvailabilityBranchBanner extends StatelessWidget {
  const _AvailabilityBranchBanner();

  @override
  Widget build(BuildContext context) {
    if (context.watch<AvailabilityBranchCubit>().state case WatchLoaded(
      :final data,
    )) {
      return AppMessageBanner(
        message: data.availabilityHoursMessage,
        variant: AppMessageBannerVariant.info,
        icon: Icons.apartment_outlined,
      );
    }
    return const SizedBox.shrink();
  }
}
