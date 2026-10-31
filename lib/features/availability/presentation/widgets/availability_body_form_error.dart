part of 'availability_body.dart';

/// Prioritizes local time errors, then preserves actionable save failures.
final class _AvailabilityFormError extends StatelessWidget {
  const _AvailabilityFormError();

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<AvailabilityWindowDraftCubit>().state;
    final save = context.watch<AvailabilityWindowSaveCubit>().state;
    if (draft.timeError case final error?) {
      return AppMessageBanner(
        message: error.availabilityMessage,
        variant: AppMessageBannerVariant.error,
      );
    }
    if (save case AvailabilityWindowSaveFailure(:final code, :final conflict)) {
      return AppMessageBanner(
        message: code.message(conflict: conflict),
        variant: AppMessageBannerVariant.error,
      );
    }
    return const SizedBox.shrink();
  }
}
