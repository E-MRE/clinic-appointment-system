part of 'availability_body.dart';

/// Removable range with an accessible warning when branch hours have changed.
final class _AvailabilityRangeChip extends StatelessWidget {
  const _AvailabilityRangeChip({required this.window});
  final AvailabilityWindow window;

  @override
  Widget build(BuildContext context) {
    final branch = context.watch<AvailabilityBranchCubit>().state;
    final saving =
        context.watch<AvailabilityWindowRemoveCubit>().state
            is AvailabilityWindowSaving;
    if (branch case WatchLoaded(:final data)) {
      final fits = window.fitsWithin(data.workingHours);
      return Semantics(
        label: fits
            ? window.range.label
            : LocaleKeys.availability_flaggedRange.translate(
                args: [window.range.label],
              ),
        child: AppTimeRangeChip(
          label: window.range.label,
          removeTooltip: LocaleKeys.availability_remove.translate(),
          variant: fits
              ? AppTimeRangeChipVariant.standard
              : AppTimeRangeChipVariant.flagged,
          onRemove: saving
              ? null
              : () {
                  context.read<AvailabilityWindowRemoveCubit>().submit(
                    context.read<AvailabilitySubject>(),
                    window,
                  );
                },
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
