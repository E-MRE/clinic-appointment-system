part of 'availability_body.dart';

/// Tracks request origin and modal lifetime without changing the shared cubit API.
final class _AvailabilityBodyActions {
  bool isSheetOpen = false;
  // Retain the latest request origin through asynchronous state delivery.
  // The next accepted operation replaces it; future completion must not.
  bool isRemoveRequest = false;

  Future<void> remove(BuildContext context, AvailabilityWindow window) async {
    final save = context.read<AvailabilityWindowSaveCubit>();
    if (save.state is AvailabilityWindowSaving || isSheetOpen) return;
    isRemoveRequest = true;
    await save.remove(context.read<AvailabilitySubject>(), window);
  }

  Future<void> openSheet(
    BuildContext context, {
    required bool showsWeekdaySelect,
  }) async {
    final save = context.read<AvailabilityWindowSaveCubit>();
    if (isSheetOpen || save.state is AvailabilityWindowSaving) return;
    final draft = context.read<AvailabilityWindowDraftCubit>();
    final availability = context.read<StaffAvailabilityCubit>();
    final branch = context.read<AvailabilityBranchCubit>();
    final durations = context.read<StaffServiceDurationsCubit>();
    final subject = context.read<AvailabilitySubject>();
    final staff = context.read<Staff>();
    isRemoveRequest = false;
    save.reset();
    isSheetOpen = true;
    try {
      // The root navigator keeps shell navigation behind the modal barrier.
      await Navigator.of(
        context,
        rootNavigator: true,
      ).context.showAppBottomSheet<void>(
        builder: (_) {
          return _AvailabilitySheetScope(
            availability: availability,
            branch: branch,
            durations: durations,
            draft: draft,
            save: save,
            subject: subject,
            staff: staff,
            showsWeekdaySelect: showsWeekdaySelect,
          );
        },
      );
    } finally {
      isSheetOpen = false;
      if (!draft.isClosed) draft.reset();
      if (!save.isClosed) save.reset();
    }
  }
}
