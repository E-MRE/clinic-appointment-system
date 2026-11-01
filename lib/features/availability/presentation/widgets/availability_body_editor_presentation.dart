part of 'availability_body.dart';

/// Opens a modal editor without retaining mutable request-origin or modal flags.
extension _AvailabilityEditorPresentation on BuildContext {
  /// Opens the mobile sheet or tablet dialog with page-owned providers by value.
  Future<void> openAvailabilityEditor({
    required bool showsWeekdaySelect,
  }) async {
    if (screenSize.isDesktop) return;
    final add = read<AvailabilityWindowAddCubit>();
    final draft = read<AvailabilityWindowDraftCubit>();
    add.reset();
    final scope = _AvailabilityModalScope(
      availability: read<StaffAvailabilityCubit>(),
      branch: read<AvailabilityBranchCubit>(),
      durations: read<StaffServiceDurationsCubit>(),
      draft: draft,
      save: add,
      subject: read<AvailabilitySubject>(),
      staff: read<Staff>(),
      child: screenSize.isMobile
          ? _AvailabilityWindowSheet(showsWeekdaySelect: showsWeekdaySelect)
          : const _AvailabilityWindowDialog(),
    );
    try {
      if (screenSize.isMobile) {
        await Navigator.of(
          this,
          rootNavigator: true,
        ).context.showAppBottomSheet<void>(
          builder: (_) {
            return scope;
          },
        );
      } else {
        await showDialog<void>(
          context: this,
          builder: (_) {
            return scope;
          },
        );
      }
    } finally {
      if (!draft.isClosed) draft.reset();
      if (!add.isClosed) add.reset();
    }
  }

  /// Sends the valid draft through the add-only request cubit.
  void submitAvailability() {
    final window = read<AvailabilityWindowDraftCubit>().state.validWindow;
    if (window == null) return;
    read<AvailabilityWindowAddCubit>().submit(
      read<AvailabilitySubject>(),
      window,
    );
  }
}
