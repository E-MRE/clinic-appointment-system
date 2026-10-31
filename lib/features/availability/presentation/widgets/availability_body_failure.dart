part of 'availability_body.dart';

/// Recoverable observation failure that restarts both schedule and branch watches.
final class _AvailabilityFailure extends StatelessWidget {
  const _AvailabilityFailure({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return ErrorState(
      title: LocaleKeys.availability_failureTitle.translate(),
      message: message,
      icon: Icon(
        Icons.error_outline,
        color: context.colorScheme.onErrorContainer,
      ),
      iconBackground: context.colorScheme.errorContainer,
      primaryAction: FilledButton(
        onPressed: () {
          context.read<StaffAvailabilityCubit>().retry();
          context.read<AvailabilityBranchCubit>().retry();
        },
        child: AppText.label(
          LocaleKeys.availability_retry.translate(),
          tone: TextTone.onPrimary,
        ),
      ),
    );
  }
}
