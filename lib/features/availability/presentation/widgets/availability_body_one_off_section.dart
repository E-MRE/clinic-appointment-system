part of 'availability_body.dart';

/// Dated extra windows and their add action, reusable by wider layouts.
final class _AvailabilityOneOffSection extends StatelessWidget {
  const _AvailabilityOneOffSection();

  @override
  Widget build(BuildContext context) {
    final availability = context.watch<StaffAvailabilityCubit>().state;
    if (availability case WatchLoaded(:final data)) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: AppSizes.s12,
        children: [
          Semantics(
            header: true,
            child: AppText.sectionTitle(
              LocaleKeys.availability_oneOffTitle.translate(),
            ),
          ),
          if (data.oneOff.isEmpty)
            AppMutedMessage(
              message: LocaleKeys.availability_oneOffEmpty.translate(),
            ),
          for (final window in data.oneOff)
            _AvailabilityOneOffItem(window: window),
          const _AvailabilityOneOffAddButton(),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
