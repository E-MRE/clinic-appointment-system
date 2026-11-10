part of 'availability_body.dart';

/// Prioritizes local time errors, then preserves actionable save failures.
final class _AvailabilityFormError extends StatelessWidget {
  const _AvailabilityFormError();

  @override
  Widget build(BuildContext context) {
    final draft = context.watch<AvailabilityWindowDraftCubit>().state;
    final save = context.watch<AvailabilityWindowAddCubit>().state;
    final error = draft.timeError;
    if (error != null) {
      return AppMessageBanner(
        message: error.availabilityMessage,
        variant: AppMessageBannerVariant.error,
      );
    }
    if (save is AvailabilityWindowSaveFailure) {
      return AppMessageBanner(
        message: save.code.message(conflict: save.conflict),
        variant: AppMessageBannerVariant.error,
      );
    }
    return const SizedBox.shrink();
  }
}
