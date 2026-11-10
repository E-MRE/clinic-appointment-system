part of 'availability_body.dart';

/// Informs staff of the branch hours constraining their availability.
final class _AvailabilityBranchBanner extends StatelessWidget {
  const _AvailabilityBranchBanner();

  @override
  Widget build(BuildContext context) {
    final branch = context.watch<AvailabilityBranchCubit>().state;
    if (branch is WatchLoaded<Branch, InstitutionErrorCode>) {
      return AppMessageBanner(
        message: branch.data.availabilityHoursMessage,
        variant: AppMessageBannerVariant.info,
        icon: Icons.apartment_outlined,
      );
    }
    return const SizedBox.shrink();
  }
}
