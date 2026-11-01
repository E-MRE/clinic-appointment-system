part of 'availability_body.dart';

/// Counts slots using one injected generator and the latest service durations.
final class _AvailabilityWindowPreview extends StatefulWidget {
  const _AvailabilityWindowPreview();

  @override
  State<_AvailabilityWindowPreview> createState() {
    return _AvailabilityWindowPreviewState();
  }
}

/// Retains the generator while drafts and assigned durations change.
final class _AvailabilityWindowPreviewState
    extends State<_AvailabilityWindowPreview> {
  late final SlotGenerator _generator;

  @override
  void initState() {
    super.initState();
    _generator = AppDependency.injector.get<SlotGenerator>();
  }

  @override
  Widget build(BuildContext context) {
    final window = context
        .watch<AvailabilityWindowDraftCubit>()
        .state
        .validWindow;
    final durations = context.watch<StaffServiceDurationsCubit>().state;
    if (window == null) return const SizedBox.shrink();
    return AppMessageBanner(
      message: AvailabilityPreview(window, switch (durations) {
        WatchLoaded(:final data) => data,
        _ => const [],
      }, _generator).message,
      variant: AppMessageBannerVariant.highlight,
    );
  }
}
